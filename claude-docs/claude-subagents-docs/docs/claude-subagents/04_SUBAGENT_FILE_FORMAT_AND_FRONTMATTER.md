# 04. Subagent 파일 형식과 Frontmatter

## 1. 기본 구조

Subagent는 Markdown 파일 + YAML frontmatter로 정의한다.

```markdown
---
name: code-reviewer
description: Reviews code for quality and best practices
tools: Read, Glob, Grep
model: sonnet
---

You are a code reviewer...
```

- frontmatter: 구성 정보
- body: system prompt 역할

## 2. 필수 필드

### name
- 고유 식별자
- 소문자와 하이픈 사용

### description
- Claude가 언제 이 agent에 위임해야 하는지 판단하는 기준
- 자동 delegation 품질을 좌우하는 핵심 필드

## 3. 주요 선택 필드

### tools
허용 도구 목록

### disallowedTools
금지 도구 목록

### model
`sonnet`, `opus`, `haiku`, `inherit`, 혹은 전체 모델 ID

### permissionMode
`default`, `acceptEdits`, `auto`, `dontAsk`, `bypassPermissions`, `plan`

### maxTurns
subagent가 종료되기 전 최대 에이전틱 턴 수

### skills
시작 시 preload할 skills 목록

### mcpServers
해당 subagent에서 사용할 MCP 서버

### hooks
subagent 수명주기 동안 적용할 hooks

### memory
`user`, `project`, `local`

### background
항상 background task로 실행할지 여부

### effort
추론 강도

### isolation
`worktree` 설정 시 임시 git worktree에서 실행

### color
UI 식별용 색상

### initialPrompt
main session agent로 실행될 때 첫 user turn 자동 주입

## 4. body 작성 원칙

body는 단순 설명문이 아니라 subagent의 system prompt다.  
따라서 다음을 포함하는 것이 좋다.

- 역할 정의
- 작업 절차
- 출력 형식
- 금지 사항
- 품질 기준

## 5. 좋은 description 작성법

설명이 모호하면 delegation이 잘못된다.

나쁜 예:
- “helps with code”

좋은 예:
- “Debugging specialist for errors, test failures, and unexpected behavior. Use proactively when encountering runtime errors or failing tests.”

## 6. 작성 권장 템플릿

```markdown
---
name: <agent-name>
description: <언제 이 agent를 써야 하는지>
tools: Read, Grep, Glob
model: sonnet
permissionMode: default
---

You are a specialized <role>.

When invoked:
1. ...
2. ...
3. ...

Focus on:
- ...
- ...
- ...

Return:
- summary
- evidence
- next action
```
