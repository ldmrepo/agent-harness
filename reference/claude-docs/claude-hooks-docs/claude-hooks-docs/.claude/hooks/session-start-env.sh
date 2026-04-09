#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${CLAUDE_ENV_FILE:-}" ]]; then
  {
    echo 'export PROJECT_ENV=development'
    echo 'export PATH="$PATH:$CLAUDE_PROJECT_DIR/node_modules/.bin"'
  } >> "$CLAUDE_ENV_FILE"
fi

jq -n '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: "이 프로젝트는 수정 후 lint와 테스트 게이트를 사용합니다. 민감 파일(.env, 키 파일, 배포 설정)은 보호 대상입니다."
  }
}'
