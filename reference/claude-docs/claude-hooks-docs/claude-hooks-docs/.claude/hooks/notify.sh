#!/usr/bin/env bash
set -euo pipefail

INPUT="$(cat)"
TYPE="$(echo "$INPUT" | jq -r '.notification_type')"
MESSAGE="$(echo "$INPUT" | jq -r '.message')"
TITLE="$(echo "$INPUT" | jq -r '.title // "Claude Code"')"

case "$(uname -s)" in
  Darwin)
    osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\""
    ;;
  Linux)
    notify-send "$TITLE" "$MESSAGE"
    ;;
  *)
    echo "[$TYPE] $TITLE - $MESSAGE" >&2
    ;;
esac
