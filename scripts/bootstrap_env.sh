#!/usr/bin/env bash
set -euo pipefail

# =========================================================
# scripts/bootstrap_env.sh
# Environment bootstrap helper for long-running agent harness
# Template Version: {{HARNESS_TEMPLATE_VERSION}}
# Project Name: {{PROJECT_NAME}}
# =========================================================

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
STATE_DIR="${ROOT_DIR}/{{STATE_DIR_NAME}}"
LOG_DIR="${ROOT_DIR}/{{LOG_DIR_NAME}}"
PID_DIR="${ROOT_DIR}/{{PID_DIR_NAME}}"

mkdir -p "$STATE_DIR" "$LOG_DIR" "$PID_DIR"
cd "$ROOT_DIR"

# shellcheck source=scripts/_common.sh
source "${ROOT_DIR}/scripts/_common.sh"

ENV_FILE="{{ENV_FILE}}"
BOOTSTRAP_LOG_FILE="${LOG_DIR}/{{BOOTSTRAP_LOG_FILENAME}}"
BOOTSTRAP_STATE_FILE="${STATE_DIR}/{{BOOTSTRAP_STATE_FILENAME}}"
LOG_FILE="$BOOTSTRAP_LOG_FILE"

echo "[bootstrap_env] project={{PROJECT_NAME}}"
echo "[bootstrap_env] repository={{REPOSITORY_NAME}}"
echo "[bootstrap_env] root_dir=$ROOT_DIR"

touch "$BOOTSTRAP_LOG_FILE"

# Relationship: scripts/bootstrap_env.sh vs init.sh
# -------------------------------------------------
# scripts/bootstrap_env.sh is a structured alternative with
# file-based logging and granular state tracking. It writes to
# a dedicated bootstrap state file for programmatic consumption.
#
# init.sh is the primary bootstrap entry point for the harness.
# It performs full environment setup with verbose logging to stdout.
# Use init.sh as the value for {{CMD_BOOTSTRAP}}.
#
# Projects should choose ONE as their primary bootstrap path.

run_step() {
  local step_name="$1"
  local cmd="$2"

  if [ -z "$cmd" ]; then
    log "[bootstrap_env][skip] ${step_name}: command empty"
    return 0
  fi

  log "[bootstrap_env][start] ${step_name}"
  if bash -lc "$cmd" >> "$BOOTSTRAP_LOG_FILE" 2>&1; then
    log "[bootstrap_env][pass] ${step_name}"
    return 0
  else
    log "[bootstrap_env][fail] ${step_name}"
    return 1
  fi
}

write_state() {
  local status="$1"
  cat > "$BOOTSTRAP_STATE_FILE" <<EOF
{
  "template_version": "{{HARNESS_TEMPLATE_VERSION}}",
  "project_name": "{{PROJECT_NAME}}",
  "repository_name": "{{REPOSITORY_NAME}}",
  "status": "$status",
  "env_file": "{{ENV_FILE}}",
  "install_enabled": "{{BOOTSTRAP_ENABLE_INSTALL}}",
  "infra_enabled": "{{BOOTSTRAP_ENABLE_INFRA}}",
  "db_migrate_enabled": "{{BOOTSTRAP_ENABLE_DB_MIGRATE}}",
  "preflight_enabled": "{{BOOTSTRAP_ENABLE_PREFLIGHT}}",
  "app_start_enabled": "{{BOOTSTRAP_ENABLE_APP_START}}",
  "worker_start_enabled": "{{BOOTSTRAP_ENABLE_WORKER_START}}",
  "healthcheck_enabled": "{{BOOTSTRAP_ENABLE_HEALTHCHECK}}",
  "updated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
}

if [ -n "$ENV_FILE" ] && [ -f "$ENV_FILE" ]; then
  log "[bootstrap_env] loading env file: $ENV_FILE"
  # shellcheck disable=SC1090
  set -a
  source "$ENV_FILE"
  set +a
else
  log "[bootstrap_env] env file missing or not configured: $ENV_FILE"
fi

write_state "running"

if [ "{{BOOTSTRAP_ENABLE_INSTALL}}" = "true" ]; then
  run_step "install" "{{CMD_INSTALL}}" || {
    write_state "failed"
    exit 1
  }
fi

if [ "{{BOOTSTRAP_ENABLE_INFRA}}" = "true" ]; then
  run_step "infra_up" "{{CMD_INFRA_UP}}" || {
    write_state "failed"
    exit 1
  }
fi

if [ "{{BOOTSTRAP_ENABLE_DB_MIGRATE}}" = "true" ]; then
  run_step "db_migrate" "{{CMD_DB_MIGRATE}}" || {
    write_state "failed"
    exit 1
  }
fi

if [ "{{BOOTSTRAP_ENABLE_PREFLIGHT}}" = "true" ]; then
  run_step "preflight_1" "{{CMD_PREFLIGHT_1}}" || {
    write_state "failed"
    exit 1
  }
  run_step "preflight_2" "{{CMD_PREFLIGHT_2}}" || {
    write_state "failed"
    exit 1
  }
  run_step "preflight_3" "{{CMD_PREFLIGHT_3}}" || {
    write_state "failed"
    exit 1
  }
fi

APP_PID_FILE="${PID_DIR}/{{APP_PID_FILENAME}}"
APP_LOG_FILE="${LOG_DIR}/{{APP_LOG_FILENAME}}"

if [ "{{BOOTSTRAP_ENABLE_APP_START}}" = "true" ] && [ -n "{{CMD_DEV}}" ]; then
  log "[bootstrap_env][start] app"
  nohup bash -lc "{{CMD_DEV}}" > "$APP_LOG_FILE" 2>&1 &
  echo $! > "$APP_PID_FILE"
  log "[bootstrap_env][pass] app pid=$(cat "$APP_PID_FILE")"
fi

WORKER_PID_FILE="${PID_DIR}/{{WORKER_PID_FILENAME}}"
WORKER_LOG_FILE="${LOG_DIR}/{{WORKER_LOG_FILENAME}}"

if [ "{{BOOTSTRAP_ENABLE_WORKER_START}}" = "true" ] && [ -n "{{CMD_WORKER}}" ]; then
  log "[bootstrap_env][start] worker"
  nohup bash -lc "{{CMD_WORKER}}" > "$WORKER_LOG_FILE" 2>&1 &
  echo $! > "$WORKER_PID_FILE"
  log "[bootstrap_env][pass] worker pid=$(cat "$WORKER_PID_FILE")"
fi

WAIT_SECONDS="{{BOOTSTRAP_WAIT_SECONDS}}"
if [ -n "$WAIT_SECONDS" ] && [ "$WAIT_SECONDS" != "0" ]; then
  log "[bootstrap_env] waiting ${WAIT_SECONDS}s for stabilization"
  sleep "$WAIT_SECONDS"
fi

if [ "{{BOOTSTRAP_ENABLE_HEALTHCHECK}}" = "true" ] && [ -n "{{HEALTHCHECK_URL}}" ]; then
  run_step "healthcheck" "curl -fsS {{HEALTHCHECK_URL}} >/dev/null" || {
    write_state "failed"
    exit 1
  }
fi

if [ "{{BOOTSTRAP_ENABLE_POST_BOOTSTRAP}}" = "true" ]; then
  run_step "post_bootstrap_1" "{{CMD_POST_BOOTSTRAP_1}}" || {
    write_state "failed"
    exit 1
  }
  run_step "post_bootstrap_2" "{{CMD_POST_BOOTSTRAP_2}}" || {
    write_state "failed"
    exit 1
  }
fi

write_state "passed"
log "[bootstrap_env] completed successfully"