# Skill 구조와 Frontmatter

## 1. 기본 구조

Skill은 두 부분으로 구성된다.

1. YAML frontmatter
2. markdown 본문

예시:
```yaml
---
name: explain-code
description: Explains code with visual diagrams and analogies
---
```

## 2. skill 내용 유형

### 참조형(reference content)
지식, 패턴, 규칙 제공

예:
- API conventions
- style guide
- domain knowledge

### 작업형(task content)
명시적 단계가 있는 실행 워크플로우

예:
- deploy
- commit
- code generation
- release checklist

## 3. 주요 frontmatter 필드

| 필드 | 의미 |
|---|---|
| `name` | skill 표시 이름 |
| `description` | skill 설명 및 자동 사용 판단 기준 |
| `argument-hint` | 자동완성 시 인자 힌트 |
| `disable-model-invocation` | Claude 자동 호출 금지 |
| `user-invocable` | `/` 메뉴 노출 제어 |
| `allowed-tools` | skill 활성 중 자동 허용 도구 |
| `model` | skill 활성 시 사용할 모델 |
| `effort` | 추론 effort override |
| `context` | `fork` 시 subagent 컨텍스트 사용 |
| `agent` | `context: fork` 시 사용할 subagent 타입 |
| `hooks` | skill 수명주기 범위 hook |
| `paths` | 자동 활성 파일 경로 조건 |
| `shell` | inline shell command용 shell |

## 4. description 작성 원칙

- 핵심 use case를 앞부분에 배치
- 자연어 요청 키워드를 포함
- 250자 이상은 skill listing에서 잘릴 수 있으므로 핵심을 먼저 작성

## 5. 예시

```yaml
---
name: deploy
description: Deploy the application to production
context: fork
disable-model-invocation: true
allowed-tools: Bash(gh *) Read Grep
---
```
