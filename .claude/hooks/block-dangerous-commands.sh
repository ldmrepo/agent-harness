#!/usr/bin/env bash
set -euo pipefail

# block-dangerous-commands.sh
# PreToolUse hook: Block dangerous bash commands (rm -rf, git push --force, git reset --hard)

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))")

BLOCKED=false
REASON=""

if echo "$COMMAND" | grep -qE 'rm\s+(-[a-zA-Z]*r[a-zA-Z]*f|--recursive.*--force|-rf|-fr)'; then
  BLOCKED=true
  REASON="rm -rf is blocked by harness policy."
fi

if echo "$COMMAND" | grep -qE 'git\s+push\s+.*--force'; then
  BLOCKED=true
  REASON="git push --force is blocked by harness policy."
fi

if echo "$COMMAND" | grep -qE 'git\s+reset\s+--hard' && ! echo "$COMMAND" | grep -q 'rollback_last_good'; then
  BLOCKED=true
  REASON="git reset --hard is only allowed via scripts/rollback_last_good.sh."
fi

if [ "$BLOCKED" = "true" ]; then
  echo "{\"hookSpecificOutput\":{\"permissionDecision\":\"deny\"},\"systemMessage\":\"[HOOK] $REASON\"}" >&2
  exit 2
fi

echo "{}"
exit 0
