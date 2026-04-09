#!/usr/bin/env bash
set -euo pipefail

# =========================================================
# scripts/rollback_last_good.sh
# Rollback helper for long-running agent harness
# Template Version: {{HARNESS_TEMPLATE_VERSION}}
# Project Name: {{PROJECT_NAME}}
# =========================================================

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
STATE_DIR="${ROOT_DIR}/{{STATE_DIR_NAME}}"
LOG_DIR="${ROOT_DIR}/{{LOG_DIR_NAME}}"

mkdir -p "$STATE_DIR" "$LOG_DIR"
cd "$ROOT_DIR"

# shellcheck source=scripts/_common.sh
source "${ROOT_DIR}/scripts/_common.sh"

ROLLBACK_LOG_FILE="${LOG_DIR}/{{ROLLBACK_LOG_FILENAME}}"
ROLLBACK_STATE_FILE="${STATE_DIR}/{{ROLLBACK_STATE_FILENAME}}"
LOG_FILE="$ROLLBACK_LOG_FILE"

touch "$ROLLBACK_LOG_FILE"

write_state() {
  local status="$1"
  local target_commit="$2"
  local reason="$3"

  cat > "$ROLLBACK_STATE_FILE" <<EOF
{
  "template_version": "{{HARNESS_TEMPLATE_VERSION}}",
  "project_name": "{{PROJECT_NAME}}",
  "repository_name": "{{REPOSITORY_NAME}}",
  "status": "$status",
  "target_commit": $(json_escape "$target_commit"),
  "reason": $(json_escape "$reason"),
  "updated_at": "{{UPDATED_AT}}"
}
EOF
}

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "{{CURRENT_BRANCH_FALLBACK}}")"
CURRENT_COMMIT="$(git rev-parse HEAD 2>/dev/null || echo "")"

log "[rollback] project={{PROJECT_NAME}}"
log "[rollback] repository={{REPOSITORY_NAME}}"
log "[rollback] branch=${CURRENT_BRANCH}"
log "[rollback] current_commit=${CURRENT_COMMIT}"

if [ "{{ROLLBACK_ENABLED}}" != "true" ]; then
  log "[rollback] rollback disabled by policy"
  write_state "skipped" "" "rollback disabled"
  exit 0
fi

if [ "{{ROLLBACK_REQUIRE_CLEAN_WORKTREE}}" = "true" ]; then
  if ! git diff --quiet || ! git diff --cached --quiet; then
    log "[rollback] blocked: worktree is dirty"
    write_state "blocked" "" "worktree dirty"
    exit 1
  fi
fi

TARGET_COMMIT="${1:-{{ROLLBACK_TARGET_COMMIT}}}"
ROLLBACK_REASON="${2:-{{ROLLBACK_REASON}}}"

if [ -z "$TARGET_COMMIT" ]; then
  if [ -n "{{ROLLBACK_FALLBACK_REF}}" ]; then
    TARGET_COMMIT="{{ROLLBACK_FALLBACK_REF}}"
  else
    log "[rollback] no target commit or fallback ref configured"
    write_state "blocked" "" "no rollback target"
    exit 1
  fi
fi

if ! git rev-parse --verify "$TARGET_COMMIT" >/dev/null 2>&1; then
  log "[rollback] invalid target commit/ref: ${TARGET_COMMIT}"
  write_state "failed" "$TARGET_COMMIT" "invalid target"
  exit 1
fi

RESOLVED_TARGET="$(git rev-parse "$TARGET_COMMIT" 2>/dev/null || echo "$TARGET_COMMIT")"
log "[rollback] resolved_target=${RESOLVED_TARGET}"

if [ "{{ROLLBACK_MODE}}" = "soft" ]; then
  log "[rollback] mode=soft"
  git reset --soft "$RESOLVED_TARGET" >> "$ROLLBACK_LOG_FILE" 2>&1
elif [ "{{ROLLBACK_MODE}}" = "mixed" ]; then
  log "[rollback] mode=mixed"
  git reset --mixed "$RESOLVED_TARGET" >> "$ROLLBACK_LOG_FILE" 2>&1
else
  log "[rollback] mode=hard"
  git reset --hard "$RESOLVED_TARGET" >> "$ROLLBACK_LOG_FILE" 2>&1
fi

if [ "{{ROLLBACK_CLEAN_UNTRACKED}}" = "true" ]; then
  log "[rollback] cleaning untracked files"
  git clean -fd >> "$ROLLBACK_LOG_FILE" 2>&1
fi

if [ "{{ROLLBACK_RUN_STATUS_COLLECT}}" = "true" ] && [ -n "{{CMD_COLLECT_STATUS}}" ]; then
  log "[rollback] collecting status after rollback"
  bash -lc "{{CMD_COLLECT_STATUS}}" >> "$ROLLBACK_LOG_FILE" 2>&1 || true
fi

if [ "{{ROLLBACK_RUN_SMOKE_AFTER}}" = "true" ] && [ -n "{{CMD_SMOKE}}" ]; then
  log "[rollback] running smoke after rollback"
  if bash -lc "{{CMD_SMOKE}}" >> "$ROLLBACK_LOG_FILE" 2>&1; then
    log "[rollback] smoke passed after rollback"
  else
    log "[rollback] smoke failed after rollback"
    write_state "partial" "$RESOLVED_TARGET" "rollback completed but smoke failed"
    exit 1
  fi
fi

write_state "passed" "$RESOLVED_TARGET" "$ROLLBACK_REASON"
log "[rollback] completed successfully"
echo "$RESOLVED_TARGET"