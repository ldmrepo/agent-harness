#!/usr/bin/env bash
set -euo pipefail

# =========================================================
# verification/verify_all.sh
# Long-running coding-agent harness full verification
# Template Version: {{HARNESS_TEMPLATE_VERSION}}
# Project Name: {{PROJECT_NAME}}
# =========================================================

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
STATE_DIR="${ROOT_DIR}/{{STATE_DIR_NAME}}"
LOG_DIR="${ROOT_DIR}/{{LOG_DIR_NAME}}"
REPORT_FILE="${STATE_DIR}/{{VERIFY_ALL_REPORT_FILENAME}}"

mkdir -p "$STATE_DIR"
mkdir -p "$LOG_DIR"

cd "$ROOT_DIR"

# shellcheck source=scripts/_common.sh
source "${ROOT_DIR}/scripts/_common.sh"

echo "[verify_all] project={{PROJECT_NAME}}"
echo "[verify_all] repository={{REPOSITORY_NAME}}"
echo "[verify_all] root_dir=$ROOT_DIR"

# ---------------------------------------------------------
# 1. Init Report
# ---------------------------------------------------------
cat > "$REPORT_FILE" <<EOF
{
  "template_version": "{{HARNESS_TEMPLATE_VERSION}}",
  "project_name": "{{PROJECT_NAME}}",
  "repository_name": "{{REPOSITORY_NAME}}",
  "verification_type": "verify_all",
  "started_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "checks": [
EOF

VERIFY_FAILED=0

# ---------------------------------------------------------
# 3. Optional Smoke-First Gate
# ---------------------------------------------------------
if [ "{{VERIFY_ALL_RUN_SMOKE_FIRST}}" = "true" ]; then
  if [ -n "{{CMD_SMOKE}}" ]; then
    if run_check "smoke_gate" "{{CMD_SMOKE}}"; then
      append_result "smoke_gate" "passed" "{{CMD_SMOKE}}" "$REPORT_FILE"
    else
      append_result "smoke_gate" "failed" "{{CMD_SMOKE}}" "$REPORT_FILE"
      VERIFY_FAILED=1
    fi
  fi
fi

# ---------------------------------------------------------
# 4. Lint Check
# ---------------------------------------------------------
if [ "{{VERIFY_ENABLE_LINT}}" = "true" ]; then
  if [ -n "{{CMD_LINT}}" ]; then
    if run_check "lint" "{{CMD_LINT}}"; then
      append_result "lint" "passed" "{{CMD_LINT}}" "$REPORT_FILE"
    else
      append_result "lint" "failed" "{{CMD_LINT}}" "$REPORT_FILE"
      VERIFY_FAILED=1
    fi
  else
    append_result "lint" "skipped" "CMD_LINT is empty" "$REPORT_FILE"
  fi
fi

# ---------------------------------------------------------
# 5. Type Check
# ---------------------------------------------------------
if [ "{{VERIFY_ENABLE_TYPECHECK}}" = "true" ]; then
  if [ -n "{{CMD_TYPECHECK}}" ]; then
    if run_check "typecheck" "{{CMD_TYPECHECK}}"; then
      append_result "typecheck" "passed" "{{CMD_TYPECHECK}}" "$REPORT_FILE"
    else
      append_result "typecheck" "failed" "{{CMD_TYPECHECK}}" "$REPORT_FILE"
      VERIFY_FAILED=1
    fi
  else
    append_result "typecheck" "skipped" "CMD_TYPECHECK is empty" "$REPORT_FILE"
  fi
fi

# ---------------------------------------------------------
# 6. Unit Tests
# ---------------------------------------------------------
if [ "{{VERIFY_ENABLE_UNIT}}" = "true" ]; then
  if [ -n "{{CMD_TEST_UNIT}}" ]; then
    if run_check "unit_tests" "{{CMD_TEST_UNIT}}"; then
      append_result "unit_tests" "passed" "{{CMD_TEST_UNIT}}" "$REPORT_FILE"
    else
      append_result "unit_tests" "failed" "{{CMD_TEST_UNIT}}" "$REPORT_FILE"
      VERIFY_FAILED=1
    fi
  else
    append_result "unit_tests" "skipped" "CMD_TEST_UNIT is empty" "$REPORT_FILE"
  fi
fi

# ---------------------------------------------------------
# 7. Integration Tests
# ---------------------------------------------------------
if [ "{{VERIFY_ENABLE_INTEGRATION}}" = "true" ]; then
  if [ -n "{{CMD_TEST_INTEGRATION}}" ]; then
    if run_check "integration_tests" "{{CMD_TEST_INTEGRATION}}"; then
      append_result "integration_tests" "passed" "{{CMD_TEST_INTEGRATION}}" "$REPORT_FILE"
    else
      append_result "integration_tests" "failed" "{{CMD_TEST_INTEGRATION}}" "$REPORT_FILE"
      VERIFY_FAILED=1
    fi
  else
    append_result "integration_tests" "skipped" "CMD_TEST_INTEGRATION is empty" "$REPORT_FILE"
  fi
fi

# ---------------------------------------------------------
# 8. E2E Tests
# ---------------------------------------------------------
if [ "{{VERIFY_ENABLE_E2E}}" = "true" ]; then
  if [ -n "{{CMD_TEST_E2E}}" ]; then
    if run_check "e2e_tests" "{{CMD_TEST_E2E}}"; then
      append_result "e2e_tests" "passed" "{{CMD_TEST_E2E}}" "$REPORT_FILE"
    else
      append_result "e2e_tests" "failed" "{{CMD_TEST_E2E}}" "$REPORT_FILE"
      VERIFY_FAILED=1
    fi
  else
    append_result "e2e_tests" "skipped" "CMD_TEST_E2E is empty" "$REPORT_FILE"
  fi
fi

# ---------------------------------------------------------
# 9. Build Check
# ---------------------------------------------------------
if [ "{{VERIFY_ENABLE_BUILD}}" = "true" ]; then
  if [ -n "{{CMD_BUILD}}" ]; then
    if run_check "build" "{{CMD_BUILD}}"; then
      append_result "build" "passed" "{{CMD_BUILD}}" "$REPORT_FILE"
    else
      append_result "build" "failed" "{{CMD_BUILD}}" "$REPORT_FILE"
      VERIFY_FAILED=1
    fi
  else
    append_result "build" "skipped" "CMD_BUILD is empty" "$REPORT_FILE"
  fi
fi

# ---------------------------------------------------------
# 10. Schema / Contract Check
# ---------------------------------------------------------
if [ "{{VERIFY_ENABLE_SCHEMA_CHECK}}" = "true" ]; then
  if [ -n "{{CMD_SCHEMA_CHECK}}" ]; then
    if run_check "schema_check" "{{CMD_SCHEMA_CHECK}}"; then
      append_result "schema_check" "passed" "{{CMD_SCHEMA_CHECK}}" "$REPORT_FILE"
    else
      append_result "schema_check" "failed" "{{CMD_SCHEMA_CHECK}}" "$REPORT_FILE"
      VERIFY_FAILED=1
    fi
  else
    append_result "schema_check" "skipped" "CMD_SCHEMA_CHECK is empty" "$REPORT_FILE"
  fi
fi

# ---------------------------------------------------------
# 11. Security Check
# ---------------------------------------------------------
if [ "{{VERIFY_ENABLE_SECURITY_CHECK}}" = "true" ]; then
  if [ -n "{{CMD_SECURITY_CHECK}}" ]; then
    if run_check "security_check" "{{CMD_SECURITY_CHECK}}"; then
      append_result "security_check" "passed" "{{CMD_SECURITY_CHECK}}" "$REPORT_FILE"
    else
      append_result "security_check" "failed" "{{CMD_SECURITY_CHECK}}" "$REPORT_FILE"
      VERIFY_FAILED=1
    fi
  else
    append_result "security_check" "skipped" "CMD_SECURITY_CHECK is empty" "$REPORT_FILE"
  fi
fi

# ---------------------------------------------------------
# 12. Performance Smoke Check
# ---------------------------------------------------------
if [ "{{VERIFY_ENABLE_PERF_SMOKE}}" = "true" ]; then
  if [ -n "{{CMD_PERF_SMOKE}}" ]; then
    if run_check "perf_smoke" "{{CMD_PERF_SMOKE}}"; then
      append_result "perf_smoke" "passed" "{{CMD_PERF_SMOKE}}" "$REPORT_FILE"
    else
      append_result "perf_smoke" "failed" "{{CMD_PERF_SMOKE}}" "$REPORT_FILE"
      VERIFY_FAILED=1
    fi
  else
    append_result "perf_smoke" "skipped" "CMD_PERF_SMOKE is empty" "$REPORT_FILE"
  fi
fi

# ---------------------------------------------------------
# 13. Custom Full Verification Checks
# ---------------------------------------------------------
if [ "{{VERIFY_ENABLE_CUSTOM_CHECKS}}" = "true" ]; then
  if [ -n "{{CMD_VERIFY_CUSTOM_1}}" ]; then
    if run_check "custom_verify_1" "{{CMD_VERIFY_CUSTOM_1}}"; then
      append_result "custom_verify_1" "passed" "{{CMD_VERIFY_CUSTOM_1}}" "$REPORT_FILE"
    else
      append_result "custom_verify_1" "failed" "{{CMD_VERIFY_CUSTOM_1}}" "$REPORT_FILE"
      VERIFY_FAILED=1
    fi
  fi

  if [ -n "{{CMD_VERIFY_CUSTOM_2}}" ]; then
    if run_check "custom_verify_2" "{{CMD_VERIFY_CUSTOM_2}}"; then
      append_result "custom_verify_2" "passed" "{{CMD_VERIFY_CUSTOM_2}}" "$REPORT_FILE"
    else
      append_result "custom_verify_2" "failed" "{{CMD_VERIFY_CUSTOM_2}}" "$REPORT_FILE"
      VERIFY_FAILED=1
    fi
  fi

  if [ -n "{{CMD_VERIFY_CUSTOM_3}}" ]; then
    if run_check "custom_verify_3" "{{CMD_VERIFY_CUSTOM_3}}"; then
      append_result "custom_verify_3" "passed" "{{CMD_VERIFY_CUSTOM_3}}" "$REPORT_FILE"
    else
      append_result "custom_verify_3" "failed" "{{CMD_VERIFY_CUSTOM_3}}" "$REPORT_FILE"
      VERIFY_FAILED=1
    fi
  fi
fi

# ---------------------------------------------------------
# 14. Review Gate Hook
# ---------------------------------------------------------
if [ "{{VERIFY_ENABLE_REVIEW_GATE_HOOK}}" = "true" ]; then
  if [ -n "{{CMD_REVIEW_GATE_HOOK}}" ]; then
    if run_check "review_gate_hook" "{{CMD_REVIEW_GATE_HOOK}}"; then
      append_result "review_gate_hook" "passed" "{{CMD_REVIEW_GATE_HOOK}}" "$REPORT_FILE"
    else
      append_result "review_gate_hook" "failed" "{{CMD_REVIEW_GATE_HOOK}}" "$REPORT_FILE"
      VERIFY_FAILED=1
    fi
  else
    append_result "review_gate_hook" "skipped" "CMD_REVIEW_GATE_HOOK is empty" "$REPORT_FILE"
  fi
fi

# ---------------------------------------------------------
# 15. Finalize Report
# ---------------------------------------------------------
TMP_FILE="$(mktemp)"
sed '$ s/,$//' "$REPORT_FILE" > "$TMP_FILE"
mv "$TMP_FILE" "$REPORT_FILE"

cat >> "$REPORT_FILE" <<EOF
  ],
  "result": "{{VERIFY_ALL_RESULT_PLACEHOLDER}}",
  "finished_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF

if [ "$VERIFY_FAILED" -eq 0 ]; then
  TMP_FILE="$(mktemp)"
  sed 's/"result": "{{VERIFY_ALL_RESULT_PLACEHOLDER}}"/"result": "passed"/' "$REPORT_FILE" > "$TMP_FILE"
  mv "$TMP_FILE" "$REPORT_FILE"
  echo "[verify_all] completed: PASSED"
  exit 0
else
  TMP_FILE="$(mktemp)"
  sed 's/"result": "{{VERIFY_ALL_RESULT_PLACEHOLDER}}"/"result": "failed"/' "$REPORT_FILE" > "$TMP_FILE"
  mv "$TMP_FILE" "$REPORT_FILE"
  echo "[verify_all] completed: FAILED"
  exit 1
fi