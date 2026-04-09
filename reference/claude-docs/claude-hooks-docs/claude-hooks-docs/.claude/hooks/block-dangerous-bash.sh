#!/usr/bin/env bash
set -euo pipefail

INPUT="$(cat)"
COMMAND="$(echo "$INPUT" | jq -r '.tool_input.command // ""')"

if [[ "$COMMAND" =~ rm[[:space:]]+-rf ]] || [[ "$COMMAND" =~ (^|[[:space:]])sudo[[:space:]]+rm ]]; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: "파괴적 삭제 명령은 hook 정책으로 차단됩니다."
    }
  }'
  exit 0
fi

exit 0
