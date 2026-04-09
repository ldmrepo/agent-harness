#!/usr/bin/env bash
set -euo pipefail

INPUT="$(cat)"
FILE_PATH="$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')"

case "$FILE_PATH" in
  *.env|*.pem|*.key|*/.env|*/secrets/*|*/deploy/prod/*)
    jq -n --arg path "$FILE_PATH" '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "ask",
        permissionDecisionReason: ("보호 파일 편집 감지: " + $path)
      }
    }'
    ;;
  *)
    exit 0
    ;;
esac
