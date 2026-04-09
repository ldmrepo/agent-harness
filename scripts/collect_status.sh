#!/usr/bin/env bash
set -euo pipefail

# =========================================================
# scripts/collect_status.sh
# Repository/runtime status collector for long-running agent harness
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

STATUS_FILE="${STATE_DIR}/{{STATUS_REPORT_FILENAME}}"
COLLECT_LOG_FILE="${LOG_DIR}/{{STATUS_LOG_FILENAME}}"
LOG_FILE="$COLLECT_LOG_FILE"

touch "$COLLECT_LOG_FILE"

read_first_line_or_empty() {
  local file_path="$1"
  if [ -f "$file_path" ]; then
    head -n 1 "$file_path" 2>/dev/null || true
  else
    echo ""
  fi
}

process_running() {
  local pid_file="$1"
  if [ -f "$pid_file" ]; then
    local pid
    pid="$(cat "$pid_file" 2>/dev/null || true)"
    if [ -n "$pid" ] && kill -0 "$pid" >/dev/null 2>&1; then
      echo "true"
      return
    fi
  fi
  echo "false"
}

healthcheck_status() {
  if [ "{{STATUS_ENABLE_HEALTHCHECK}}" = "true" ] && [ -n "{{HEALTHCHECK_URL}}" ]; then
    if command -v curl >/dev/null 2>&1; then
      if curl -fsS "{{HEALTHCHECK_URL}}" >/dev/null 2>&1; then
        echo "passed"
      else
        echo "failed"
      fi
    else
      echo "not_available"
    fi
  else
    echo "disabled"
  fi
}

port_status() {
  if [ "{{STATUS_ENABLE_PORT_CHECK}}" = "true" ] && [ -n "{{STATUS_TARGET_HOST}}" ] && [ -n "{{STATUS_TARGET_PORT}}" ]; then
    if command -v nc >/dev/null 2>&1; then
      if nc -z "{{STATUS_TARGET_HOST}}" "{{STATUS_TARGET_PORT}}" >/dev/null 2>&1; then
        echo "open"
      else
        echo "closed"
      fi
    else
      echo "not_available"
    fi
  else
    echo "disabled"
  fi
}

git_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "{{CURRENT_BRANCH_FALLBACK}}")"
git_commit="$(git rev-parse HEAD 2>/dev/null || echo "")"
git_dirty="false"
if ! git diff --quiet >/dev/null 2>&1; then
  git_dirty="true"
fi

app_pid_file="${PID_DIR}/{{APP_PID_FILENAME}}"
worker_pid_file="${PID_DIR}/{{WORKER_PID_FILENAME}}"

app_running="$(process_running "$app_pid_file")"
worker_running="$(process_running "$worker_pid_file")"
health_status="$(healthcheck_status)"
port_check_status="$(port_status)"

progress_head="$(read_first_line_or_empty "{{PROGRESS_FILE_PATH}}")"
current_task_head="$(read_first_line_or_empty "{{CURRENT_TASK_FILE_PATH}}")"
known_issues_head="$(read_first_line_or_empty "{{KNOWN_ISSUES_FILE_PATH}}")"

log "[collect_status] project={{PROJECT_NAME}}"
log "[collect_status] repository={{REPOSITORY_NAME}}"
log "[collect_status] branch=${git_branch}"
log "[collect_status] commit=${git_commit}"
log "[collect_status] app_running=${app_running}"
log "[collect_status] worker_running=${worker_running}"
log "[collect_status] health_status=${health_status}"
log "[collect_status] port_check_status=${port_check_status}"

cat > "$STATUS_FILE" <<EOF
{
  "template_version": "{{HARNESS_TEMPLATE_VERSION}}",
  "project_name": "{{PROJECT_NAME}}",
  "repository_name": "{{REPOSITORY_NAME}}",
  "collected_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "repository": {
    "root_dir": $(json_escape "$ROOT_DIR"),
    "branch": $(json_escape "$git_branch"),
    "commit": $(json_escape "$git_commit"),
    "git_dirty": ${git_dirty}
  },
  "runtime": {
    "app_pid_file": $(json_escape "$app_pid_file"),
    "worker_pid_file": $(json_escape "$worker_pid_file"),
    "app_running": ${app_running},
    "worker_running": ${worker_running},
    "healthcheck_status": $(json_escape "$health_status"),
    "port_check_status": $(json_escape "$port_check_status")
  },
  "artifacts": {
    "progress_file": $(json_escape "{{PROGRESS_FILE_PATH}}"),
    "current_task_file": $(json_escape "{{CURRENT_TASK_FILE_PATH}}"),
    "known_issues_file": $(json_escape "{{KNOWN_ISSUES_FILE_PATH}}"),
    "progress_file_present": $([ -f "{{PROGRESS_FILE_PATH}}" ] && echo true || echo false),
    "current_task_file_present": $([ -f "{{CURRENT_TASK_FILE_PATH}}" ] && echo true || echo false),
    "known_issues_file_present": $([ -f "{{KNOWN_ISSUES_FILE_PATH}}" ] && echo true || echo false),
    "progress_head": $(json_escape "$progress_head"),
    "current_task_head": $(json_escape "$current_task_head"),
    "known_issues_head": $(json_escape "$known_issues_head")
  },
  "environment": {
    "env_file": $(json_escape "{{ENV_FILE}}"),
    "healthcheck_url": $(json_escape "{{HEALTHCHECK_URL}}"),
    "status_target_host": $(json_escape "{{STATUS_TARGET_HOST}}"),
    "status_target_port": $(json_escape "{{STATUS_TARGET_PORT}}")
  }
}
EOF

log "[collect_status] status report written: $STATUS_FILE"
echo "$STATUS_FILE"