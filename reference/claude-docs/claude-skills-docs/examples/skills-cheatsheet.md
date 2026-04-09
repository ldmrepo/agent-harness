# Skills 빠른 참조

## 생성
```bash
mkdir -p ~/.claude/skills/my-skill
```

## 최소 SKILL.md
```yaml
---
name: my-skill
description: Briefly describe what this skill does and when to use it
---

Your instructions here.
```

## 직접 호출
```text
/my-skill
/my-skill some arguments
```

## 자주 쓰는 frontmatter
```yaml
disable-model-invocation: true
user-invocable: false
allowed-tools: Read Grep Glob
context: fork
agent: Explore
argument-hint: [issue-number]
paths:
  - "src/**/*.ts"
```

## 치환 변수
- `$ARGUMENTS`
- `$ARGUMENTS[0]`
- `$0`
- `${CLAUDE_SESSION_ID}`
- `${CLAUDE_SKILL_DIR}`

## 대표 패턴
- 설명형 skill
- 배포형 skill
- 조사형 skill
- PR 요약 skill
- 시각화 skill

## 운영 원칙
- description은 짧고 구체적으로
- side effect skill은 자동 호출 금지
- supporting files 적극 활용
- `SKILL.md`는 500줄 이하 권장
