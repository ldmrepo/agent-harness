# 05. Tools, Permissions, Models

## 1. Tools 제어

### tools
allowlist 방식이다. 명시한 도구만 허용한다.

예:
```yaml
tools: Read, Grep, Glob, Bash
```

### disallowedTools
denylist 방식이다. 상속된 도구 중 일부를 제거한다.

예:
```yaml
disallowedTools: Write, Edit
```

### 동시 사용 시
`disallowedTools`가 먼저 적용되고, 그 뒤 `tools`가 남은 풀에서 해석된다.

## 2. Agent spawning 제한

main thread agent로 동작할 때는 `Agent(...)` 문법으로 어떤 하위 agent를 생성할 수 있는지 제한할 수 있다.

예:
```yaml
tools: Agent(worker, researcher), Read, Bash
```

주의:
- subagent는 다른 subagent를 spawn할 수 없다
- 이 제약은 main agent에서만 실질 의미가 있다

## 3. Permission Mode

### default
기본 permission 확인

### acceptEdits
파일 수정 일부 자동 승인

### auto
classifier가 명령/보호 디렉토리 쓰기를 평가

### dontAsk
허용되지 않은 permission은 자동 거부

### bypassPermissions
강력한 무프롬프트 모드

### plan
읽기 전용 계획 수립용

## 4. 부모 세션과의 관계

- 부모가 `bypassPermissions`면 override 불가
- 부모가 `auto`면 subagent frontmatter의 `permissionMode`는 무시되고 auto 상속

즉, subagent 권한은 완전히 독립적이라기보다 부모 제약을 일부 상속한다.

## 5. Model 선택

`model`은 다음 중 하나를 쓸 수 있다.

- alias: `sonnet`, `opus`, `haiku`
- full model id
- `inherit`

기본값은 사실상 `inherit`이다.

## 6. 모델 해석 우선순위

1. `CLAUDE_CODE_SUBAGENT_MODEL`
2. 호출 시 전달된 `model`
3. frontmatter의 `model`
4. main conversation model

## 7. 설계 패턴

### read-only researcher
- tools: Read, Grep, Glob
- model: haiku 또는 sonnet
- permissionMode: plan/default

### fixer/debugger
- tools: Read, Edit, Bash, Grep, Glob
- model: sonnet
- permissionMode: default

### expensive architect
- tools: Read, Grep, Glob
- model: opus
- effort: high/max
