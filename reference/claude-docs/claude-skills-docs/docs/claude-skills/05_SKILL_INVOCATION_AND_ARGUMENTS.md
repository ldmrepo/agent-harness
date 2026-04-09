# Skill 호출과 인자 처리

## 1. 호출 방식

### 자동 호출
Claude가 description을 보고 관련성이 높을 때 skill을 로드한다.

### 직접 호출
사용자가 `/skill-name`으로 호출한다.

예:
```text
/explain-code src/auth/login.ts
```

## 2. Invocation control

### `disable-model-invocation: true`
Claude 자동 호출 금지. 사용자가 직접 호출해야 한다.

적합 사례:
- `/deploy`
- `/commit`
- `/send-slack-message`

### `user-invocable: false`
사용자 메뉴에서는 숨기고 Claude만 자동 호출 가능하게 한다.

적합 사례:
- legacy system background knowledge
- 도메인 문맥 보조 스킬

## 3. 인자 치환

사용 가능한 치환 변수:

- `$ARGUMENTS`
- `$ARGUMENTS[N]`
- `$N`
- `${CLAUDE_SESSION_ID}`
- `${CLAUDE_SKILL_DIR}`

## 4. `$ARGUMENTS` 동작

skill 본문에 `$ARGUMENTS`가 없으면 Claude Code는 자동으로 끝에 다음 형식으로 덧붙인다.

```text
ARGUMENTS: <value>
```

## 5. 예시

```yaml
---
name: fix-issue
description: Fix a GitHub issue
disable-model-invocation: true
---

Fix GitHub issue $ARGUMENTS following our coding standards.
```

실행:
```text
/fix-issue 123
```

## 6. 위치 인자 예시

```yaml
---
name: migrate-component
description: Migrate a component from one framework to another
---

Migrate the $0 component from $1 to $2.
```

실행:
```text
/migrate-component SearchBar React Vue
```
