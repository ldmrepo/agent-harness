#!/usr/bin/env bash
set -euo pipefail

# =========================================================
# init.sh
# Long-running coding-agent harness bootstrap template
# Template Version: {{HARNESS_TEMPLATE_VERSION}}
# Project Name: {{PROJECT_NAME}}
# =========================================================

# Relationship: init.sh vs scripts/bootstrap_env.sh
# -------------------------------------------------
# init.sh is the primary bootstrap entry point for the harness.
# It performs full environment setup with verbose logging to stdout.
# Use this as the value for {{CMD_BOOTSTRAP}}.
#
# scripts/bootstrap_env.sh is a structured alternative with
# file-based logging and granular state tracking. It writes to
# a dedicated bootstrap state file for programmatic consumption.
#
# Projects should choose ONE as their primary bootstrap path.

# ---------------------------------------------------------
# 1. Basic Path Setup
# ---------------------------------------------------------
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
STATE_DIR="${ROOT_DIR}/{{STATE_DIR_NAME}}"
LOG_DIR="${ROOT_DIR}/{{LOG_DIR_NAME}}"
PID_DIR="${ROOT_DIR}/{{PID_DIR_NAME}}"

mkdir -p "$STATE_DIR"
mkdir -p "$LOG_DIR"
mkdir -p "$PID_DIR"

cd "$ROOT_DIR"

# shellcheck source=scripts/_common.sh
source "${ROOT_DIR}/scripts/_common.sh"

echo "[init] project={{PROJECT_NAME}}"
echo "[init] repository={{REPOSITORY_NAME}}"
echo "[init] root_dir=$ROOT_DIR"

# ---------------------------------------------------------
# 2. Environment Loading
# ---------------------------------------------------------
ENV_FILE="{{ENV_FILE}}"

if [ -n "$ENV_FILE" ] && [ -f "$ENV_FILE" ]; then
  echo "[init] loading environment file: $ENV_FILE"
  # shellcheck disable=SC1090
  set -a
  source "$ENV_FILE"
  set +a
else
  echo "[init] environment file not found or not configured: $ENV_FILE"
fi

# ---------------------------------------------------------
# 3. Utility Functions
# ---------------------------------------------------------
write_runtime_state() {
  cat > "${STATE_DIR}/environment.json" <<EOF
{
  "project_name": "{{PROJECT_NAME}}",
  "repository_name": "{{REPOSITORY_NAME}}",
  "runtime_type": "{{RUNTIME_TYPE}}",
  "primary_stack": "{{PRIMARY_STACK}}",
  "package_manager": "{{PACKAGE_MANAGER}}",
  "default_branch": "{{DEFAULT_BRANCH}}",
  "app_port": "{{APP_PORT}}",
  "api_port": "{{API_PORT}}",
  "db_port": "{{DB_PORT}}",
  "cache_port": "{{CACHE_PORT}}",
  "env_file": "{{ENV_FILE}}",
  "updated_at": "{{UPDATED_AT}}"
}
EOF
}

# ---------------------------------------------------------
# 4. Runtime State Snapshot
# ---------------------------------------------------------
write_runtime_state
echo "[init] runtime state written to ${STATE_DIR}/environment.json"

# ---------------------------------------------------------
# 5. Dependency Installation
# ---------------------------------------------------------
INSTALL_ENABLED="{{BOOTSTRAP_ENABLE_INSTALL}}"

if [ "$INSTALL_ENABLED" = "true" ]; then
  echo "[init] dependency installation enabled"
  if [ -n "{{CMD_INSTALL}}" ]; then
    run_or_warn "running install command" "{{CMD_INSTALL}}"
  else
    echo "[init][warn] CMD_INSTALL is empty"
  fi
else
  echo "[init] dependency installation disabled"
fi

# ---------------------------------------------------------
# 6. Optional Local Infrastructure Startup
# ---------------------------------------------------------
INFRA_ENABLED="{{BOOTSTRAP_ENABLE_INFRA}}"

if [ "$INFRA_ENABLED" = "true" ]; then
  echo "[init] infrastructure bootstrap enabled"

  if [ -n "{{CMD_INFRA_UP}}" ]; then
    run_or_warn "starting local infrastructure" "{{CMD_INFRA_UP}}"
  else
    echo "[init] no infrastructure startup command configured"
  fi
else
  echo "[init] infrastructure bootstrap disabled"
fi

# ---------------------------------------------------------
# 7. Database Migration
# ---------------------------------------------------------
MIGRATION_ENABLED="{{BOOTSTRAP_ENABLE_DB_MIGRATE}}"

if [ "$MIGRATION_ENABLED" = "true" ]; then
  echo "[init] database migration enabled"
  if [ -n "{{CMD_DB_MIGRATE}}" ]; then
    run_or_warn "running database migrations" "{{CMD_DB_MIGRATE}}"
  else
    echo "[init] no database migration command configured"
  fi
else
  echo "[init] database migration disabled"
fi

# ---------------------------------------------------------
# 8. Optional Preflight Commands
# ---------------------------------------------------------
PREFLIGHT_ENABLED="{{BOOTSTRAP_ENABLE_PREFLIGHT}}"

if [ "$PREFLIGHT_ENABLED" = "true" ]; then
  echo "[init] preflight commands enabled"

  if [ -n "{{CMD_PREFLIGHT_1}}" ]; then
    run_or_warn "running preflight command 1" "{{CMD_PREFLIGHT_1}}"
  fi

  if [ -n "{{CMD_PREFLIGHT_2}}" ]; then
    run_or_warn "running preflight command 2" "{{CMD_PREFLIGHT_2}}"
  fi

  if [ -n "{{CMD_PREFLIGHT_3}}" ]; then
    run_or_warn "running preflight command 3" "{{CMD_PREFLIGHT_3}}"
  fi
else
  echo "[init] preflight commands disabled"
fi

# ---------------------------------------------------------
# 9. Application Startup
# ---------------------------------------------------------
APP_START_ENABLED="{{BOOTSTRAP_ENABLE_APP_START}}"
APP_LOG_FILE="${LOG_DIR}/{{APP_LOG_FILENAME}}"
APP_PID_FILE="${PID_DIR}/{{APP_PID_FILENAME}}"

if [ "$APP_START_ENABLED" = "true" ]; then
  echo "[init] application startup enabled"

  if [ -n "{{CMD_DEV}}" ]; then
    echo "[init] starting application with command: {{CMD_DEV}}"
    nohup bash -lc "{{CMD_DEV}}" > "$APP_LOG_FILE" 2>&1 &
    APP_PID=$!
    echo "$APP_PID" > "$APP_PID_FILE"
    echo "[init] app pid=$APP_PID"
    echo "[init] app log=$APP_LOG_FILE"
  else
    echo "[init][warn] CMD_DEV is empty"
  fi
else
  echo "[init] application startup disabled"
fi

# ---------------------------------------------------------
# 10. Optional Secondary Process Startup
# ---------------------------------------------------------
WORKER_START_ENABLED="{{BOOTSTRAP_ENABLE_WORKER_START}}"
WORKER_LOG_FILE="${LOG_DIR}/{{WORKER_LOG_FILENAME}}"
WORKER_PID_FILE="${PID_DIR}/{{WORKER_PID_FILENAME}}"

if [ "$WORKER_START_ENABLED" = "true" ]; then
  echo "[init] worker startup enabled"

  if [ -n "{{CMD_WORKER}}" ]; then
    echo "[init] starting worker with command: {{CMD_WORKER}}"
    nohup bash -lc "{{CMD_WORKER}}" > "$WORKER_LOG_FILE" 2>&1 &
    WORKER_PID=$!
    echo "$WORKER_PID" > "$WORKER_PID_FILE"
    echo "[init] worker pid=$WORKER_PID"
    echo "[init] worker log=$WORKER_LOG_FILE"
  else
    echo "[init][warn] CMD_WORKER is empty"
  fi
else
  echo "[init] worker startup disabled"
fi

# ---------------------------------------------------------
# 11. Stabilization Wait
# ---------------------------------------------------------
WAIT_SECONDS="{{BOOTSTRAP_WAIT_SECONDS}}"

if [ -z "$WAIT_SECONDS" ]; then
  WAIT_SECONDS="0"
fi

echo "[init] waiting ${WAIT_SECONDS}s for services to stabilize"
sleep "$WAIT_SECONDS"

# ---------------------------------------------------------
# 12. Health Check
# ---------------------------------------------------------
HEALTHCHECK_ENABLED="{{BOOTSTRAP_ENABLE_HEALTHCHECK}}"
HEALTHCHECK_URL="{{HEALTHCHECK_URL}}"

if [ "$HEALTHCHECK_ENABLED" = "true" ]; then
  echo "[init] health check enabled"

  if command_exists curl; then
    if [ -n "$HEALTHCHECK_URL" ]; then
      echo "[init] checking health: $HEALTHCHECK_URL"
      if curl -fsS "$HEALTHCHECK_URL" >/dev/null 2>&1; then
        echo "[init] health check passed"
      else
        echo "[init][warn] health check failed"
      fi
    else
      echo "[init][warn] HEALTHCHECK_URL is empty"
    fi
  else
    echo "[init][warn] curl not available; skipping health check"
  fi
else
  echo "[init] health check disabled"
fi

# ---------------------------------------------------------
# 13. Optional Post-Bootstrap Commands
# ---------------------------------------------------------
POST_BOOTSTRAP_ENABLED="{{BOOTSTRAP_ENABLE_POST_BOOTSTRAP}}"

if [ "$POST_BOOTSTRAP_ENABLED" = "true" ]; then
  echo "[init] post-bootstrap commands enabled"

  if [ -n "{{CMD_POST_BOOTSTRAP_1}}" ]; then
    run_or_warn "running post-bootstrap command 1" "{{CMD_POST_BOOTSTRAP_1}}"
  fi

  if [ -n "{{CMD_POST_BOOTSTRAP_2}}" ]; then
    run_or_warn "running post-bootstrap command 2" "{{CMD_POST_BOOTSTRAP_2}}"
  fi
else
  echo "[init] post-bootstrap commands disabled"
fi

# ---------------------------------------------------------
# 14. Bootstrap Summary
# ---------------------------------------------------------
cat > "${STATE_DIR}/bootstrap_summary.json" <<EOF
{
  "project_name": "{{PROJECT_NAME}}",
  "repository_name": "{{REPOSITORY_NAME}}",
  "install_enabled": "{{BOOTSTRAP_ENABLE_INSTALL}}",
  "infra_enabled": "{{BOOTSTRAP_ENABLE_INFRA}}",
  "db_migrate_enabled": "{{BOOTSTRAP_ENABLE_DB_MIGRATE}}",
  "preflight_enabled": "{{BOOTSTRAP_ENABLE_PREFLIGHT}}",
  "app_start_enabled": "{{BOOTSTRAP_ENABLE_APP_START}}",
  "worker_start_enabled": "{{BOOTSTRAP_ENABLE_WORKER_START}}",
  "healthcheck_enabled": "{{BOOTSTRAP_ENABLE_HEALTHCHECK}}",
  "post_bootstrap_enabled": "{{BOOTSTRAP_ENABLE_POST_BOOTSTRAP}}",
  "healthcheck_url": "{{HEALTHCHECK_URL}}",
  "app_log_file": "${APP_LOG_FILE}",
  "worker_log_file": "${WORKER_LOG_FILE}",
  "updated_at": "{{UPDATED_AT}}"
}
EOF

echo "[init] bootstrap summary written to ${STATE_DIR}/bootstrap_summary.json"
echo "[init] completed"