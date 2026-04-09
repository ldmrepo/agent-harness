#!/usr/bin/env bash
set -euo pipefail

INPUT="$(cat)"
NEW_CWD="$(echo "$INPUT" | jq -r '.new_cwd')"

if [[ -n "${CLAUDE_ENV_FILE:-}" ]]; then
  : > "$CLAUDE_ENV_FILE"

  if [[ -d "$NEW_CWD/.venv/bin" ]]; then
    {
      echo "export VIRTUAL_ENV=\"$NEW_CWD/.venv\""
      echo "export PATH=\"$NEW_CWD/.venv/bin:\$PATH\""
    } >> "$CLAUDE_ENV_FILE"
  fi

  if [[ -f "$NEW_CWD/.env.local.sh" ]]; then
    echo "source \"$NEW_CWD/.env.local.sh\"" >> "$CLAUDE_ENV_FILE"
  fi
fi
