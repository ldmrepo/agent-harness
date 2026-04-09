#!/usr/bin/env bash
set -euo pipefail

# post-edit-verify.sh
# PostToolUse hook (async): Auto-lint after Edit/Write on source files.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | python3 -c "
import json, sys
d = json.load(sys.stdin)
ti = d.get('tool_input', {})
print(ti.get('file_path', ti.get('path', '')))
")

case "$FILE_PATH" in
  *.py)
    if command -v ruff >/dev/null 2>&1; then
      RESULT=$(ruff check "$FILE_PATH" 2>&1 || true)
      if [ -n "$RESULT" ]; then
        echo "{\"systemMessage\":\"[AUTO-LINT] ruff $FILE_PATH:\\n$RESULT\"}"
        exit 0
      fi
    fi
    ;;
  *.ts|*.tsx|*.js|*.jsx)
    if command -v npx >/dev/null 2>&1; then
      RESULT=$(npx eslint "$FILE_PATH" 2>&1 || true)
      if [ -n "$RESULT" ] && ! echo "$RESULT" | grep -q "0 problems"; then
        echo "{\"systemMessage\":\"[AUTO-LINT] eslint $FILE_PATH:\\n$RESULT\"}"
        exit 0
      fi
    fi
    ;;
esac

echo "{}"
exit 0
