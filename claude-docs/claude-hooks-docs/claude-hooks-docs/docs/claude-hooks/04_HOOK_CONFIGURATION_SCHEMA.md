# Hook 설정 스키마
문서 ID: CC-HOOKS-SCHEMA
버전: v1.1.0

## 1. 기본 구조
hooks 설정은 3단계 중첩 구조를 가진다.
1. event 선택
2. matcher group 정의
3. hook handler 정의

## 2. 예시
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "if": "Bash(rm *)",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-rm.sh"
          }
        ]
      }
    ]
  }
}
```

## 3. Hook 정의 위치
- ~/.claude/settings.json
- .claude/settings.json
- .claude/settings.local.json
- managed policy settings
- plugin hooks/hooks.json
- skill/agent frontmatter

## 4. matcher 규칙
matcher는 regex string이다.
event별로 다른 필드에 매칭된다.

### 4.1 tool event matcher
- 대상: tool_name
- 예: Bash, Edit|Write, mcp__.*

### 4.2 SessionStart matcher
- startup, resume, clear, compact

### 4.3 Notification matcher
- permission_prompt, idle_prompt, auth_success, elicitation_dialog

### 4.4 InstructionsLoaded matcher
- session_start, nested_traversal, path_glob_match, include, compact

## 5. if 필드
if는 tool event에서만 동작한다.
permission rule syntax를 사용한다.
예:
- Bash(git *)
- Edit(*.ts)

## 6. command hook 필드
- type
- command
- async
- shell
- timeout
- statusMessage

## 7. http hook 필드
- type
- url
- headers
- allowedEnvVars
- timeout

## 8. prompt/agent hook 필드
- type
- prompt
- model
- timeout

## 9. once 필드
- skill에만 적용 가능
- 세션당 1회 실행 후 제거
