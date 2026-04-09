#!/usr/bin/env bash
set -euo pipefail

INPUT="$(cat)"
FILE_PATH="$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')"

case "$FILE_PATH" in
  *.ts|*.tsx|*.js|*.jsx|*.py) ;;
  *) exit 0 ;;
esac

RESULT=""
if [[ -f "$CLAUDE_PROJECT_DIR/package.json" ]]; then
  RESULT="$(cd "$CLAUDE_PROJECT_DIR" && npm run -s lint 2>&1 || true)"
elif [[ -f "$CLAUDE_PROJECT_DIR/pyproject.toml" ]]; then
  RESULT="$(cd "$CLAUDE_PROJECT_DIR" && python -m pytest -q 2>&1 || true)"
fi

if [[ -n "$RESULT" ]]; then
  jq -n --arg path "$FILE_PATH" --arg result "$RESULT" '{
    systemMessage: ("수정 후 검증 결과(" + $path + "):\n" + $result)
  }'
fi
