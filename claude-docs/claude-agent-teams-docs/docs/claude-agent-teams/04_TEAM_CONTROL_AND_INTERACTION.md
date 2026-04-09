# 04. 팀 제어와 상호작용

## 1. 리드 중심 제어 모델

사용자는 자연어로 리드에게 지시하고, 리드가 팀 전체를 조정한다.

예:
```text
Create a team with 4 teammates to refactor these modules in parallel.
Use Sonnet for each teammate.
```

## 2. 팀원 수와 모델 지정

리드가 자동 판단할 수도 있고, 사용자가 직접 지정할 수도 있다.

- 팀원 수
- 역할 이름
- 사용할 모델
- 특정 teammate의 성격

## 3. Plan approval 요구

복잡하거나 위험한 작업은 팀원이 먼저 plan mode에서 계획을 만들고, 리드가 승인한 뒤 구현하도록 강제할 수 있다.

예:
```text
Spawn an architect teammate to refactor the authentication module.
Require plan approval before they make any changes.
```

## 4. 팀원과 직접 대화

### 4.1 in-process 모드
- Shift+Down: 팀원 순환
- Enter: 팀원 세션 보기
- Escape: 현재 턴 인터럽트
- Ctrl+T: task list 토글

### 4.2 split-pane 모드
- pane 클릭으로 특정 팀원에게 직접 메시지 가능

## 5. 작업 할당 방식

### 5.1 리드가 명시적 할당
- 특정 작업을 특정 팀원에게 부여

### 5.2 팀원의 self-claim
- 팀원이 완료 후 다음 가능한 태스크를 자율적으로 가져감

## 6. 팀원 종료

```text
Ask the researcher teammate to shut down
```

리드는 종료 요청을 보낼 수 있으며, 팀원은 승인 또는 거절할 수 있다.

## 7. 팀 정리

```text
Clean up the team
```

주의사항:
- 정리는 반드시 리드가 수행해야 한다.
- 활성 팀원이 남아 있으면 정리가 실패할 수 있다.
- 먼저 팀원을 종료한 뒤 cleanup을 실행하는 것이 안전하다.
