# 08. Agent Team 모범 사례

## 1. 팀원에게 충분한 컨텍스트를 준다

리드의 대화 이력은 자동 승계되지 않으므로 spawn prompt에 작업 맥락을 충분히 포함해야 한다.

좋은 예:
```text
Spawn a security reviewer teammate with the prompt: "Review the authentication module
at src/auth/ for security vulnerabilities. Focus on token handling, session
management, and input validation."
```

## 2. 팀 규모는 작게 시작한다

권장 시작 범위:
- 3~5 teammates

이유:
- 토큰 비용 선형 증가
- 조정 복잡성 증가
- 추가 팀원의 한계효용 감소

## 3. 태스크는 적절한 크기로 자른다

### 너무 작은 경우
- 조정 오버헤드가 더 큼

### 너무 큰 경우
- 장시간 단독 작업으로 방향 오류 위험 증가

### 적절한 경우
- 명확한 산출물이 있는 self-contained task

## 4. 파일 충돌을 피한다

작업을 나눌 때 팀원별 파일 소유권을 최대한 분리한다.

## 5. 리드가 직접 일하기 시작하면 제지한다

필요하면 다음과 같이 지시한다:
```text
Wait for your teammates to complete their tasks before proceeding
```

## 6. 처음에는 조사/리뷰 작업부터 도입한다

병렬 구현보다 조사/리뷰가 agent teams의 장점을 이해하기 쉽고 리스크가 적다.

## 7. 모니터링과 중간 조정을 한다

너무 오래 unattended 상태로 두면 잘못된 방향의 작업이 누적될 수 있다.
