#!/usr/bin/env bash
set -euo pipefail

INPUT="$(cat)"
STOP_HOOK_ACTIVE="$(echo "$INPUT" | jq -r '.stop_hook_active')"
LAST_MSG="$(echo "$INPUT" | jq -r '.last_assistant_message // ""')"

if [[ "$STOP_HOOK_ACTIVE" == "true" ]]; then
  exit 0
fi

if echo "$LAST_MSG" | grep -qi "TODO\|남은 작업\|follow-up"; then
  jq -n '{
    decision: "block",
    reason: "아직 남은 작업이 있으므로 바로 종료하지 말고 후속 작업을 계속하세요."
  }'
  exit 0
fi

exit 0
