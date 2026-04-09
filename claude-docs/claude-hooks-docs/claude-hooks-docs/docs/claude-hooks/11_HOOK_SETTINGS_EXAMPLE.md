# Hook Settings 예시
문서 ID: CC-HOOKS-SETTINGS-EXAMPLE
버전: v1.1.0

## 1. 목적
이 문서는 프로젝트용 `.claude/settings.json` 예시를 제공한다.

## 2. 적용 시나리오
- 세션 시작 시 환경 주입
- 위험 Bash 차단
- 보호 파일 편집 시 사용자 확인
- 수정 후 비동기 lint/test 실행
- task 완료 전 테스트 게이트
- 디렉토리/파일 변경 시 환경 재로딩
- 설정 파일 변경 감사
- 종료 전 품질 게이트
- 권한/유휴 대기 알림 전송

## 3. 예시 설정
```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/session-start-env.sh",
            "timeout": 20,
            "statusMessage": "프로젝트 환경을 준비하는 중..."
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "if": "Bash(rm *)|Bash(mv *)|Bash(cp *)",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-bash.sh",
            "timeout": 10,
            "statusMessage": "위험 명령을 검사하는 중..."
          }
        ]
      },
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/protect-files.sh",
            "timeout": 10,
            "statusMessage": "보호 파일 편집 여부를 검사하는 중..."
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/post-edit-lint.sh",
            "async": true,
            "timeout": 300,
            "statusMessage": "수정 후 검증을 실행하는 중..."
          }
        ]
      }
    ],
    "TaskCompleted": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/task-complete-test-gate.sh",
            "timeout": 300,
            "statusMessage": "task 완료 전 테스트를 확인하는 중..."
          }
        ]
      }
    ],
    "CwdChanged": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/cwd-env-refresh.sh",
            "timeout": 15
          }
        ]
      }
    ],
    "FileChanged": [
      {
        "matcher": ".envrc|.env|package.json|pyproject.toml",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/filechange-env-refresh.sh",
            "timeout": 15
          }
        ]
      }
    ],
    "ConfigChange": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/config-audit.sh",
            "timeout": 10
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/stop-quality-gate.sh",
            "timeout": 20
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "permission_prompt|idle_prompt|elicitation_dialog",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/notify.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```
