# Subagents Cheatsheet

## 기본 위치
- Project: `.claude/agents/`
- User: `~/.claude/agents/`

## 최소 예제
```markdown
---
name: code-reviewer
description: Review code for quality and security. Use proactively after code changes.
tools: Read, Grep, Glob, Bash
model: sonnet
---

You are a focused code reviewer.
Return:
- critical issues
- warnings
- suggestions
```

## 자주 쓰는 frontmatter
- `tools`
- `disallowedTools`
- `model`
- `permissionMode`
- `skills`
- `mcpServers`
- `hooks`
- `memory`
- `background`
- `isolation`
- `color`

## 권장 패턴
- 조사 전용: `Read, Grep, Glob`
- 디버깅: `Read, Edit, Bash, Grep, Glob`
- 장기 지식 축적: `memory: project`
- 고위험 외부 작업: hook 검증 추가

## 주의
- subagent는 다른 subagent를 spawn하지 못함
- parent가 `auto` 또는 `bypassPermissions`면 일부 설정은 override 불가
- plugin subagent는 `hooks`, `mcpServers`, `permissionMode` 제한
