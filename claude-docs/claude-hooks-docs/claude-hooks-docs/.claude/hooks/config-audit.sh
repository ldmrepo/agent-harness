#!/usr/bin/env bash
set -euo pipefail

INPUT="$(cat)"
SOURCE="$(echo "$INPUT" | jq -r '.source')"
FILE_PATH="$(echo "$INPUT" | jq -r '.file_path // ""')"

mkdir -p "$CLAUDE_PROJECT_DIR/.claude/logs"
echo "$(date -Is) source=$SOURCE file=$FILE_PATH" >> "$CLAUDE_PROJECT_DIR/.claude/logs/config-change.log"

exit 0
