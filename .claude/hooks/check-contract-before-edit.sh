#!/usr/bin/env bash
set -euo pipefail

# check-contract-before-edit.sh
# PreToolUse hook: Block Edit/Write on app code when contract is not approved.
# Allows edits to tasks/, state/, .claude/, docs/, verification/, scripts/.

INPUT=$(cat)

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
CURRENT_TASK="${ROOT_DIR}/tasks/current_task.json"

if [ ! -f "$CURRENT_TASK" ]; then
  echo "{}"
  exit 0
fi

CONTRACT_STATUS=$(python3 -c "
import json
try:
    with open('$CURRENT_TASK') as f:
        data = json.load(f)
    print(data.get('contract_review', {}).get('contract_status', 'not_required'))
except:
    print('not_required')
")

if [ "$CONTRACT_STATUS" = "approved" ] || [ "$CONTRACT_STATUS" = "not_required" ]; then
  echo "{}"
  exit 0
fi

FILE_PATH=$(echo "$INPUT" | python3 -c "
import json, sys
d = json.load(sys.stdin)
ti = d.get('tool_input', {})
print(ti.get('file_path', ti.get('path', '')))
")

if echo "$FILE_PATH" | grep -qE '^(tasks/|state/|\.claude/|docs/|verification/|scripts/)'; then
  echo "{}"
  exit 0
fi

echo "{\"hookSpecificOutput\":{\"permissionDecision\":\"deny\"},\"systemMessage\":\"[HOOK] contract_status=$CONTRACT_STATUS. Contract review must be approved before implementation.\"}" >&2
exit 2
