#!/usr/bin/env bash
set -euo pipefail

# =========================================================
# scripts/commit_session.sh
# Session commit helper for long-running agent harness
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

COMMIT_LOG_FILE="${LOG_DIR}/{{COMMIT_LOG_FILENAME}}"
COMMIT_STATE_FILE="${STATE_DIR}/{{COMMIT_STATE_FILENAME}}"
LOG_FILE="$COMMIT_LOG_FILE"

touch "$COMMIT_LOG_FILE"

write_state() {
  local status="$1"
  local message="$2"

  cat > "$COMMIT_STATE_FILE" <<EOF
{
  "template_version": "{{HARNESS_TEMPLATE_VERSION}}",
  "project_name": "{{PROJECT_NAME}}",
  "repository_name": "{{REPOSITORY_NAME}}",
  "status": "$status",
  "commit_message": $(printf '%s' "$message" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))'),
  "updated_at": "{{UPDATED_AT}}"
}
EOF
}

if [ "{{ALLOW_AUTO_COMMIT}}" != "true" ]; then
  log "[commit_session] auto commit disabled by policy"
  write_state "skipped" "auto commit disabled"
  exit 0
fi

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "{{CURRENT_BRANCH_FALLBACK}}")"
CURRENT_COMMIT="$(git rev-parse HEAD 2>/dev/null || echo "")"

log "[commit_session] project={{PROJECT_NAME}}"
log "[commit_session] repository={{REPOSITORY_NAME}}"
log "[commit_session] branch=${CURRENT_BRANCH}"
log "[commit_session] base_commit=${CURRENT_COMMIT}"

if git diff --quiet && git diff --cached --quiet; then
  log "[commit_session] no changes to commit"
  write_state "skipped" "no changes"
  exit 0
fi

TASK_ID="{{WORK_ITEM_ID}}"
TASK_TYPE="{{WORK_ITEM_TYPE}}"
COMMIT_SUMMARY="{{COMMIT_MESSAGE_SUMMARY}}"

COMMIT_PREFIX="{{COMMIT_PREFIX_CHORE}}"
case "$TASK_TYPE" in
  feature)
    COMMIT_PREFIX="{{COMMIT_PREFIX_FEAT}}"
    ;;
  bugfix)
    COMMIT_PREFIX="{{COMMIT_PREFIX_FIX}}"
    ;;
  chore|refactor|bootstrap|recovery|verification)
    COMMIT_PREFIX="{{COMMIT_PREFIX_CHORE}}"
    ;;
esac

if [ -z "$TASK_ID" ]; then
  TASK_ID="{{FALLBACK_TASK_ID}}"
fi

if [ -z "$COMMIT_SUMMARY" ]; then
  COMMIT_SUMMARY="{{FALLBACK_COMMIT_SUMMARY}}"
fi

COMMIT_MESSAGE="${COMMIT_PREFIX}(${TASK_ID}): ${COMMIT_SUMMARY}"

if [ "{{COMMIT_REQUIRE_CLEAN_STATE_FLAG}}" = "true" ]; then
  CLEAN_STATE_FILE="{{SESSION_SUMMARY_FILE_PATH}}"
  if [ -f "$CLEAN_STATE_FILE" ]; then
    if ! grep -q '"clean_state_at_session_end":[[:space:]]*true' "$CLEAN_STATE_FILE"; then
      log "[commit_session] clean state flag not satisfied"
      write_state "blocked" "clean state flag not satisfied"
      exit 1
    fi
  else
    log "[commit_session] session summary file missing; cannot validate clean state"
    write_state "blocked" "session summary missing"
    exit 1
  fi
fi

if [ "{{COMMIT_STAGE_ALL}}" = "true" ]; then
  log "[commit_session] staging all changes"
  git add -A
else
  log "[commit_session] staging configured paths only"
  if [ -n "{{COMMIT_STAGE_PATH_1}}" ]; then git add "{{COMMIT_STAGE_PATH_1}}"; fi
  if [ -n "{{COMMIT_STAGE_PATH_2}}" ]; then git add "{{COMMIT_STAGE_PATH_2}}"; fi
  if [ -n "{{COMMIT_STAGE_PATH_3}}" ]; then git add "{{COMMIT_STAGE_PATH_3}}"; fi
  if [ -n "{{COMMIT_STAGE_PATH_4}}" ]; then git add "{{COMMIT_STAGE_PATH_4}}"; fi
fi

if git diff --cached --quiet; then
  log "[commit_session] nothing staged after staging rules"
  write_state "skipped" "nothing staged"
  exit 0
fi

log "[commit_session] creating commit: ${COMMIT_MESSAGE}"
git commit -m "$COMMIT_MESSAGE" >> "$COMMIT_LOG_FILE" 2>&1

NEW_COMMIT="$(git rev-parse HEAD 2>/dev/null || echo "")"
log "[commit_session] committed=${NEW_COMMIT}"

write_state "passed" "$COMMIT_MESSAGE"
echo "$COMMIT_MESSAGE"