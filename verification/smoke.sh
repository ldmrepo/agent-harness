#!/usr/bin/env bash
set -euo pipefail

# =========================================================
# verification/smoke.sh
# Long-running coding-agent harness smoke verification
# Template Version: {{HARNESS_TEMPLATE_VERSION}}
# Project Name: {{PROJECT_NAME}}
# =========================================================

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
STATE_DIR="${ROOT_DIR}/{{STATE_DIR_NAME}}"
LOG_DIR="${ROOT_DIR}/{{LOG_DIR_NAME}}"
REPORT_FILE="${STATE_DIR}/{{SMOKE_REPORT_FILENAME}}"

mkdir -p "$STATE_DIR"
mkdir -p "$LOG_DIR"

cd "$ROOT_DIR"

# shellcheck source=scripts/_common.sh
source "${ROOT_DIR}/scripts/_common.sh"

echo "[smoke] project={{PROJECT_NAME}}"
echo "[smoke] repository={{REPOSITORY_NAME}}"
echo "[smoke] root_dir=$ROOT_DIR"

# ---------------------------------------------------------
# 1. Init Report
# ---------------------------------------------------------
cat > "$REPORT_FILE" <<EOF
{
  "template_version": "{{HARNESS_TEMPLATE_VERSION}}",
  "project_name": "{{PROJECT_NAME}}",
  "repository_name": "{{REPOSITORY_NAME}}",
  "verification_type": "smoke",
  "started_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "checks": [
EOF

SMOKE_FAILED=0

# ---------------------------------------------------------
# 3. Repository Root Check
# ---------------------------------------------------------
if [ -f "${ROOT_DIR}/AGENTS.md" ]; then
  echo "[smoke] PASS: repository marker AGENTS.md found"
  append_result "repository_marker" "passed" "AGENTS.md found" "$REPORT_FILE"
else
  echo "[smoke] FAIL: repository marker AGENTS.md not found"
  append_result "repository_marker" "failed" "AGENTS.md not found" "$REPORT_FILE"
  SMOKE_FAILED=1
fi

# ---------------------------------------------------------
# 4. Required File Presence Checks
# ---------------------------------------------------------
for required_file in \
  "{{REQUIRED_FILE_1}}" \
  "{{REQUIRED_FILE_2}}" \
  "{{REQUIRED_FILE_3}}" \
  "{{REQUIRED_FILE_4}}"
do
  if [ -n "$required_file" ]; then
    if [ -e "${ROOT_DIR}/${required_file}" ]; then
      echo "[smoke] PASS: required file exists -> ${required_file}"
      append_result "required_file:${required_file}" "passed" "exists" "$REPORT_FILE"
    else
      echo "[smoke] FAIL: required file missing -> ${required_file}"
      append_result "required_file:${required_file}" "failed" "missing" "$REPORT_FILE"
      SMOKE_FAILED=1
    fi
  fi
done

# ---------------------------------------------------------
# 5. Optional Pre-Smoke Commands
# ---------------------------------------------------------
if [ "{{SMOKE_ENABLE_PRECHECKS}}" = "true" ]; then
  if [ -n "{{CMD_SMOKE_PRECHECK_1}}" ]; then
    if run_check "smoke_precheck_1" "{{CMD_SMOKE_PRECHECK_1}}"; then
      append_result "smoke_precheck_1" "passed" "{{CMD_SMOKE_PRECHECK_1}}" "$REPORT_FILE"
    else
      append_result "smoke_precheck_1" "failed" "{{CMD_SMOKE_PRECHECK_1}}" "$REPORT_FILE"
      SMOKE_FAILED=1
    fi
  fi

  if [ -n "{{CMD_SMOKE_PRECHECK_2}}" ]; then
    if run_check "smoke_precheck_2" "{{CMD_SMOKE_PRECHECK_2}}"; then
      append_result "smoke_precheck_2" "passed" "{{CMD_SMOKE_PRECHECK_2}}" "$REPORT_FILE"
    else
      append_result "smoke_precheck_2" "failed" "{{CMD_SMOKE_PRECHECK_2}}" "$REPORT_FILE"
      SMOKE_FAILED=1
    fi
  fi
fi

# ---------------------------------------------------------
# 6. Process Presence Check
# ---------------------------------------------------------
if [ "{{SMOKE_ENABLE_PROCESS_CHECK}}" = "true" ]; then
  if [ -n "{{PROCESS_MATCH_PATTERN}}" ]; then
    if pgrep -f "{{PROCESS_MATCH_PATTERN}}" >/dev/null 2>&1; then
      echo "[smoke] PASS: process pattern found -> {{PROCESS_MATCH_PATTERN}}"
      append_result "process_check" "passed" "{{PROCESS_MATCH_PATTERN}}" "$REPORT_FILE"
    else
      echo "[smoke] FAIL: process pattern not found -> {{PROCESS_MATCH_PATTERN}}"
      append_result "process_check" "failed" "{{PROCESS_MATCH_PATTERN}}" "$REPORT_FILE"
      SMOKE_FAILED=1
    fi
  fi
fi

# ---------------------------------------------------------
# 7. Port Check
# ---------------------------------------------------------
if [ "{{SMOKE_ENABLE_PORT_CHECK}}" = "true" ]; then
  if [ -n "{{SMOKE_TARGET_PORT}}" ]; then
    if command_exists nc; then
      if nc -z "{{SMOKE_TARGET_HOST}}" "{{SMOKE_TARGET_PORT}}"; then
        echo "[smoke] PASS: port reachable {{SMOKE_TARGET_HOST}}:{{SMOKE_TARGET_PORT}}"
        append_result "port_check" "passed" "{{SMOKE_TARGET_HOST}}:{{SMOKE_TARGET_PORT}}" "$REPORT_FILE"
      else
        echo "[smoke] FAIL: port not reachable {{SMOKE_TARGET_HOST}}:{{SMOKE_TARGET_PORT}}"
        append_result "port_check" "failed" "{{SMOKE_TARGET_HOST}}:{{SMOKE_TARGET_PORT}}" "$REPORT_FILE"
        SMOKE_FAILED=1
      fi
    else
      echo "[smoke][warn] nc not available; skipping port check"
      append_result "port_check" "skipped" "nc not available" "$REPORT_FILE"
    fi
  fi
fi

# ---------------------------------------------------------
# 8. Health Check
# ---------------------------------------------------------
if [ "{{SMOKE_ENABLE_HEALTHCHECK}}" = "true" ]; then
  if [ -n "{{HEALTHCHECK_URL}}" ]; then
    if command_exists curl; then
      if curl -fsS "{{HEALTHCHECK_URL}}" >/dev/null 2>&1; then
        echo "[smoke] PASS: health check {{HEALTHCHECK_URL}}"
        append_result "healthcheck" "passed" "{{HEALTHCHECK_URL}}" "$REPORT_FILE"
      else
        echo "[smoke] FAIL: health check {{HEALTHCHECK_URL}}"
        append_result "healthcheck" "failed" "{{HEALTHCHECK_URL}}" "$REPORT_FILE"
        SMOKE_FAILED=1
      fi
    else
      echo "[smoke][warn] curl not available; health check skipped"
      append_result "healthcheck" "skipped" "curl not available" "$REPORT_FILE"
    fi
  fi
fi

# ---------------------------------------------------------
# 9. Optional API Probe
# ---------------------------------------------------------
if [ "{{SMOKE_ENABLE_API_PROBE}}" = "true" ]; then
  if [ -n "{{SMOKE_API_PROBE_URL}}" ]; then
    if command_exists curl; then
      if curl -fsS "{{SMOKE_API_PROBE_URL}}" >/dev/null 2>&1; then
        echo "[smoke] PASS: api probe {{SMOKE_API_PROBE_URL}}"
        append_result "api_probe" "passed" "{{SMOKE_API_PROBE_URL}}" "$REPORT_FILE"
      else
        echo "[smoke] FAIL: api probe {{SMOKE_API_PROBE_URL}}"
        append_result "api_probe" "failed" "{{SMOKE_API_PROBE_URL}}" "$REPORT_FILE"
        SMOKE_FAILED=1
      fi
    else
      echo "[smoke][warn] curl not available; api probe skipped"
      append_result "api_probe" "skipped" "curl not available" "$REPORT_FILE"
    fi
  fi
fi

# ---------------------------------------------------------
# 10. Optional UI Probe
# ---------------------------------------------------------
if [ "{{SMOKE_ENABLE_UI_PROBE}}" = "true" ]; then
  if [ -n "{{SMOKE_UI_PROBE_COMMAND}}" ]; then
    if run_check "ui_probe" "{{SMOKE_UI_PROBE_COMMAND}}"; then
      append_result "ui_probe" "passed" "{{SMOKE_UI_PROBE_COMMAND}}" "$REPORT_FILE"
    else
      append_result "ui_probe" "failed" "{{SMOKE_UI_PROBE_COMMAND}}" "$REPORT_FILE"
      SMOKE_FAILED=1
    fi
  fi
fi

# ---------------------------------------------------------
# 11. Optional Custom Smoke Checks
# ---------------------------------------------------------
if [ "{{SMOKE_ENABLE_CUSTOM_CHECKS}}" = "true" ]; then
  if [ -n "{{CMD_SMOKE_CUSTOM_1}}" ]; then
    if run_check "custom_smoke_1" "{{CMD_SMOKE_CUSTOM_1}}"; then
      append_result "custom_smoke_1" "passed" "{{CMD_SMOKE_CUSTOM_1}}" "$REPORT_FILE"
    else
      append_result "custom_smoke_1" "failed" "{{CMD_SMOKE_CUSTOM_1}}" "$REPORT_FILE"
      SMOKE_FAILED=1
    fi
  fi

  if [ -n "{{CMD_SMOKE_CUSTOM_2}}" ]; then
    if run_check "custom_smoke_2" "{{CMD_SMOKE_CUSTOM_2}}"; then
      append_result "custom_smoke_2" "passed" "{{CMD_SMOKE_CUSTOM_2}}" "$REPORT_FILE"
    else
      append_result "custom_smoke_2" "failed" "{{CMD_SMOKE_CUSTOM_2}}" "$REPORT_FILE"
      SMOKE_FAILED=1
    fi
  fi

  if [ -n "{{CMD_SMOKE_CUSTOM_3}}" ]; then
    if run_check "custom_smoke_3" "{{CMD_SMOKE_CUSTOM_3}}"; then
      append_result "custom_smoke_3" "passed" "{{CMD_SMOKE_CUSTOM_3}}" "$REPORT_FILE"
    else
      append_result "custom_smoke_3" "failed" "{{CMD_SMOKE_CUSTOM_3}}" "$REPORT_FILE"
      SMOKE_FAILED=1
    fi
  fi
fi

# ---------------------------------------------------------
# 12. Finalize Report
# ---------------------------------------------------------
TMP_FILE="$(mktemp)"
sed '$ s/,$//' "$REPORT_FILE" > "$TMP_FILE"
mv "$TMP_FILE" "$REPORT_FILE"

cat >> "$REPORT_FILE" <<EOF
  ],
  "result": "{{SMOKE_RESULT_PLACEHOLDER}}",
  "finished_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF

if [ "$SMOKE_FAILED" -eq 0 ]; then
  TMP_FILE="$(mktemp)"
  sed 's/"result": "{{SMOKE_RESULT_PLACEHOLDER}}"/"result": "passed"/' "$REPORT_FILE" > "$TMP_FILE"
  mv "$TMP_FILE" "$REPORT_FILE"
  echo "[smoke] completed: PASSED"
  exit 0
else
  TMP_FILE="$(mktemp)"
  sed 's/"result": "{{SMOKE_RESULT_PLACEHOLDER}}"/"result": "failed"/' "$REPORT_FILE" > "$TMP_FILE"
  mv "$TMP_FILE" "$REPORT_FILE"
  echo "[smoke] completed: FAILED"
  exit 1
fi