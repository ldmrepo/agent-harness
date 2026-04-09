#!/usr/bin/env bash
set -euo pipefail

# check-smoke-before-edit.sh
# PreToolUse hook: Block Edit/Write on app code when smoke is failing.
# Allows edits to verification/, scripts/, state/, .claude/ for recovery.

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SMOKE_REPORT="${ROOT_DIR}/state/smoke_report.json"

if [ ! -f "$SMOKE_REPORT" ]; then
  echo "{}"
  exit 0
fi

SMOKE_RESULT=$(python3 -c "
import json
try:
    with open('$SMOKE_REPORT') as f:
        print(json.load(f).get('result', 'unknown'))
except:
    print('unknown')
")

if [ "$SMOKE_RESULT" = "failed" ]; then
  INPUT=$(cat)
  FILE_PATH=$(echo "$INPUT" | python3 -c "
import json, sys
d = json.load(sys.stdin)
ti = d.get('tool_input', {})
print(ti.get('file_path', ti.get('path', '')))
")

  if echo "$FILE_PATH" | grep -qE '^(verification/|scripts/|state/|\.claude/)'; then
    echo "{}"
    exit 0
  fi

  echo "{\"hookSpecificOutput\":{\"permissionDecision\":\"deny\"},\"systemMessage\":\"[HOOK] Smoke verification is failing. Fix smoke before editing app code. Run: bash ./verification/smoke.sh\"}" >&2
  exit 2
fi

echo "{}"
exit 0
