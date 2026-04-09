# 07. Agent Team 사용 사례와 패턴

## 1. 병렬 코드 리뷰

### 목적
하나의 PR을 보안, 성능, 테스트 커버리지 등 서로 다른 기준으로 병렬 검토한다.

### 장점
- 리뷰 관점 분리
- 누락 감소
- 결과 종합 용이

### 예시 프롬프트
```text
Create an agent team to review PR #142. Spawn three reviewers:
- One focused on security implications
- One checking performance impact
- One validating test coverage
Have them each review and report findings.
```

## 2. 경쟁 가설 디버깅

### 목적
서로 다른 원인 가설을 병렬 검증한다.

### 장점
- 초기 가설 고착 방지
- 반증 중심 조사 가능
- 더 빠른 수렴

### 예시 프롬프트
```text
Users report the app exits after one message instead of staying connected.
Spawn 5 agent teammates to investigate different hypotheses. Have them talk to
each other to try to disprove each other's theories.
```

## 3. 신기능 분업 구현

### 패턴
- teammate A: UI
- teammate B: backend API
- teammate C: tests / integration

### 장점
- 계층 분업이 명확함
- 서로 다른 파일 집합을 맡기기 쉬움

## 4. 신규 모듈 설계 검토

### 패턴
- UX 관점
- 구조 관점
- 반대자 관점

### 장점
- 설계의 약점이 초기에 드러남
- 대안 비교가 쉬움

## 5. cross-layer coordination

프론트엔드/백엔드/테스트처럼 서로 다른 레이어를 동시에 진행해야 할 때 유리하다.

## 6. 적합하지 않은 패턴

- 같은 파일을 여러 팀원이 동시에 수정
- 결과보다 조정 비용이 큰 작은 작업
- 선후 관계가 지나치게 강한 작업
