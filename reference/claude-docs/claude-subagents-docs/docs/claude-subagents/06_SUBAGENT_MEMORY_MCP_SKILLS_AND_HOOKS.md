# 06. Memory, MCP, Skills, Hooks

## 1. Persistent Memory

`memory` 필드는 subagent에 지속 메모리 디렉토리를 부여한다.

- `user`: `~/.claude/agent-memory/<agent>/`
- `project`: `.claude/agent-memory/<agent>/`
- `local`: `.claude/agent-memory-local/<agent>/`

## 2. Memory 동작

memory가 활성화되면:

- subagent system prompt에 memory 읽기/쓰기 지침이 추가된다
- `MEMORY.md`의 첫 200줄 또는 25KB가 주입된다
- Read/Write/Edit가 자동 활성화된다

## 3. 추천 scope

- 기본 추천: `project`
- 개인 일반 지식 축적: `user`
- 버전관리 제외 지식: `local`

## 4. Skills preload

`skills` 필드를 사용하면 subagent 시작 시 skill 전체 콘텐츠가 주입된다.

```yaml
skills:
  - api-conventions
  - error-handling-patterns
```

중요:
- parent conversation의 skills를 자동 상속하지 않는다
- 여기 적은 skills만 preload된다

## 5. MCP servers

`mcpServers`는 subagent 전용 외부 도구 연결을 부여한다.

### 방식
- 문자열 참조: 기존 세션에 설정된 MCP server 이름 재사용
- inline 정의: subagent 시작 시 연결되고 종료 시 해제

예:
```yaml
mcpServers:
  - github
  - playwright:
      type: stdio
      command: npx
      args: ["-y", "@playwright/mcp@latest"]
```

## 6. Hooks

subagent frontmatter 안에 hooks를 정의할 수 있다.

대표 이벤트:
- PreToolUse
- PostToolUse
- Stop(실행 시 SubagentStop으로 변환)

예:
```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-command.sh"
```

## 7. Project-level hook와의 차이

### frontmatter hooks
- 해당 subagent가 active일 때만 적용
- lifecycle 끝나면 정리됨

### settings.json hooks
- main session에서 subagent lifecycle 이벤트를 감시
- `SubagentStart`, `SubagentStop` 등 사용

## 8. 실무 패턴

- DB reader + PreToolUse hook = read-only SQL 제약
- Browser tester + inline MCP = subagent 전용 browser access
- Reviewer + project memory = 장기적 코드 패턴 축적
