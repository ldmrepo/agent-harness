# 10. 운영, 보안, 트러블슈팅

## 1. 운영 원칙

### 작게 시작
처음부터 복잡한 agent를 만들지 말고, 목적이 분명한 1개 역할부터 만든다.

### 권한 최소화
가능하면 `Read/Grep/Glob`부터 시작하고, 정말 필요할 때만 `Edit`, `Write`, `Bash`, MCP를 추가한다.

### description 관리
자동 delegation 실패의 가장 흔한 원인은 description이 부정확하거나 너무 일반적인 것이다.

## 2. 보안 원칙

- `bypassPermissions`는 매우 신중히 사용
- DB, 배포, 외부 시스템 접근은 hook 또는 별도 validator와 함께 설계
- plugin agent는 보안 제한이 있음을 이해하고 사용
- memory는 scope에 따라 공유 범위를 명확히 관리

## 3. 자주 발생하는 문제

### 자동 위임이 안 됨
원인:
- description이 너무 모호함
- 이름은 좋지만 언제 써야 하는지 설명이 부족함

해결:
- “Use proactively when …” 식으로 구체화

### 너무 자주 위임됨
원인:
- description이 과도하게 넓음

해결:
- 적용 조건을 축소
- 특정 도메인/상황 키워드만 남김

### 필요한 도구가 없음
원인:
- tools 또는 disallowedTools 설정 과도
- parent permission 영향

해결:
- 실제 필요한 도구만 다시 명시
- parent mode 확인

### plugin subagent에서 일부 기능이 안 됨
원인:
- plugin subagent는 `hooks`, `mcpServers`, `permissionMode` 제한

해결:
- `.claude/agents/` 또는 `~/.claude/agents/`로 복사해 사용

### background subagent가 중간에 실패
원인:
- 추가 permission 또는 clarifying question 필요

해결:
- foreground로 재실행
- 사전 permission 확보

## 4. 추천 운영 템플릿

### 팀 공용
- `.claude/agents/`
- reviewer/debugger/researcher 3종 세트

### 개인 공용
- `~/.claude/agents/`
- 개인 선호 reviewer, explainer, summarizer

### 통제형 agent
- 최소 tools
- hook 검증
- memory scope 명시

## 5. 최종 체크리스트

- [ ] description이 delegation 기준을 분명히 설명하는가
- [ ] tools가 최소 권한 원칙을 따르는가
- [ ] permissionMode가 부모 세션과 충돌하지 않는가
- [ ] memory scope가 의도한 공유 범위와 일치하는가
- [ ] hook/validator가 필요한 위험 작업에 적용되었는가
- [ ] foreground/background 선택 기준이 명확한가
