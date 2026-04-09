#!/usr/bin/env bash
set -euo pipefail

cd "$CLAUDE_PROJECT_DIR"

if [[ -f package.json ]]; then
  npm test >/tmp/claude-task-test.log 2>&1 || {
    echo "테스트 실패로 task 완료를 막습니다. /tmp/claude-task-test.log 를 확인하세요." >&2
    exit 2
  }
elif [[ -f pyproject.toml ]]; then
  python -m pytest -q >/tmp/claude-task-test.log 2>&1 || {
    echo "pytest 실패로 task 완료를 막습니다. /tmp/claude-task-test.log 를 확인하세요." >&2
    exit 2
  }
fi
