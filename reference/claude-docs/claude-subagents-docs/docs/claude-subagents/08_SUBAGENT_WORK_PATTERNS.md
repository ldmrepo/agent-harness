# 08. Subagent 작업 패턴

## 1. 고출력 작업 격리

테스트 전체 실행, 대규모 로그 조사, 문서 검색 같은 작업은 subagent로 분리하는 것이 유리하다.

예:
- “테스트 전체를 subagent로 돌리고 실패한 케이스만 요약해”

## 2. 병렬 조사

독립적인 조사 주제가 있을 때 여러 subagent를 병렬로 사용한다.

예:
- 인증 모듈
- DB 모듈
- API 모듈

각자 조사 후 메인에서 종합.

## 3. 순차 체인

하나의 subagent 결과를 다음 subagent 입력 조건으로 쓰는 패턴.

예:
- reviewer가 문제 찾기
- optimizer가 개선
- tester가 검증

## 4. 메인 대화에 남길지 여부

### 메인 대화에 적합
- 짧고 반복적인 질의응답
- 설계-구현-검증이 강하게 연결된 작업
- 즉시 수정이 필요한 작은 작업

### subagent에 적합
- 자기완결적 작업
- 대량 조사/분석
- 권한 격리가 필요한 작업
- 결과만 요약 받으면 되는 작업

## 5. BTW와 구분

이미 대화에 있는 문맥에 대한 짧은 옆질문은 `/btw`가 더 적합하다.  
subagent는 도구 사용과 독립 context가 필요할 때 쓰는 것이 맞다.

## 6. 좋은 description 패턴

설명에 다음 표현을 넣으면 자동 delegation 가능성이 높아진다.

- “Use proactively when…”
- “Use immediately after…”
- “Use when encountering…”

## 7. 조직 운영 패턴

- reviewer 계열: read-only
- debugger 계열: limited edit
- deploy 계열: strong permission + hooks
- data 계열: Bash + validation hooks
