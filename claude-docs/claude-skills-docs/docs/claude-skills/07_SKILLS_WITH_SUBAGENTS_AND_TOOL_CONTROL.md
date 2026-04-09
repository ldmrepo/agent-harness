# Skills + Subagents + Tool Control

## 1. `context: fork`

`context: fork`를 주면 skill은 격리된 subagent 컨텍스트에서 실행된다.

주의:
- 단순 참고 지침만 있고 실행 작업이 없으면 의미 있는 결과가 나오기 어렵다.
- fork skill은 명시적 task 지시가 있어야 한다.

## 2. `agent` 필드

`context: fork`일 때 어떤 subagent 타입을 사용할지 지정한다.

가능 예:
- `Explore`
- `Plan`
- `general-purpose`
- custom subagent

## 3. 예시

```yaml
---
name: deep-research
description: Research a topic thoroughly
context: fork
agent: Explore
---

Research $ARGUMENTS thoroughly:
1. Find relevant files
2. Read and analyze the code
3. Summarize findings
```

## 4. allowed-tools

skill이 활성일 때 특정 도구를 추가 허용할 수 있다.

예:
```yaml
---
name: safe-reader
description: Read files without making changes
allowed-tools: Read Grep Glob
---
```

## 5. Skill tool 접근 제어

### 모든 skill 비활성
권한 규칙에서 `Skill` deny

### 특정 skill만 허용/차단
예:
```text
Skill(commit)
Skill(review-pr *)
Skill(deploy *)
```

### 개별 skill 숨김
`disable-model-invocation: true`

## 6. 주의사항

- `user-invocable: false`는 UI 노출 제어일 뿐, Skill tool 접근 차단이 아니다.
- programmatic invocation 차단은 `disable-model-invocation: true`를 사용한다.
