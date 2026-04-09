#!/usr/bin/env bash
set -euo pipefail

# stop-progress-gate.sh
# Stop hook: Block session stop if no progress entry exists for today.

INPUT=$(cat)

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
PROGRESS_FILE="${ROOT_DIR}/claude-progress.txt"

if [ ! -f "$PROGRESS_FILE" ]; then
  echo "{\"hookSpecificOutput\":{\"decision\":\"block\"},\"systemMessage\":\"[HOOK] claude-progress.txt does not exist. Write a progress entry before ending the session.\"}"
  exit 0
fi

TODAY=$(date +%Y-%m-%d)
if grep -q "$TODAY" "$PROGRESS_FILE"; then
  echo "{}"
  exit 0
fi

STOP_HOOK_ACTIVE=$(echo "$INPUT" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    print(str(d.get('stop_hook_active', False)).lower())
except:
    print('false')
" 2>/dev/null || echo "false")

if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  echo "{}"
  exit 0
fi

echo "{\"hookSpecificOutput\":{\"decision\":\"block\"},\"systemMessage\":\"[HOOK] No progress entry for today ($TODAY). Write a session entry to claude-progress.txt before stopping.\"}"
exit 0
