#!/usr/bin/env bash
set -euo pipefail

INPUT="$(cat)"
FILE_PATH="$(echo "$INPUT" | jq -r '.file_path')"
EVENT="$(echo "$INPUT" | jq -r '.event')"

if [[ -n "${CLAUDE_ENV_FILE:-}" ]]; then
  echo "# watched file changed: $FILE_PATH ($EVENT)" >> "$CLAUDE_ENV_FILE"
fi

jq -n --arg path "$FILE_PATH" --arg ev "$EVENT" '{
  systemMessage: ("감시 파일 변경 감지: " + $path + " (" + $ev + ")")
}'
