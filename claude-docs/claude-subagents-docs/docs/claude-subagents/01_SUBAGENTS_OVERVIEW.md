# 01. Subagents 개요

## 1. 정의

Subagent는 특정 유형의 작업을 담당하도록 분리된 AI 작업자이다.  
각 subagent는 다음 특성을 가진다.

- 별도 context window 사용
- 자체 system prompt 사용
- 개별 tool access 제어 가능
- 독립 permission 처리
- 작업 완료 후 요약 결과를 부모 세션으로 반환

즉, main conversation이 모든 탐색·실행·실험의 중간 산출물을 직접 들고 가지 않도록 분리하는 장치다.

## 2. 왜 필요한가

Subagent는 다음 문제를 해결한다.

### 2.1 컨텍스트 절약
코드 탐색, 로그 조사, 대량 검색 결과를 메인 대화에 모두 남기지 않아도 된다.

### 2.2 역할 특화
리뷰 전용, 디버깅 전용, 데이터 분석 전용처럼 행위를 분리할 수 있다.

### 2.3 제약 부여
어떤 subagent는 Read/Grep만 허용하고, 어떤 subagent는 Bash와 Edit까지 허용하는 식으로 권한을 나눌 수 있다.

### 2.4 비용 제어
간단한 탐색은 Haiku, 복잡한 분석은 Sonnet/Opus로 분리할 수 있다.

## 3. Agent teams와 차이

Subagents는 단일 세션 내부에서 동작한다.  
반면 agent teams는 여러 독립 세션이 서로 메시지를 주고받는 구조다.

정리하면:

- subagents: 단일 세션 내부의 격리 작업자
- agent teams: 여러 Claude Code 세션의 협업 구조

## 4. 주요 사용 시나리오

- 코드베이스 조사 결과만 요약 받고 싶을 때
- 테스트 실패 분석을 별도 컨텍스트에서 진행하고 싶을 때
- 특정 보안/품질 규칙을 강제하는 전문 reviewer가 필요할 때
- 데이터베이스 조회 전용 작업자를 만들고 싶을 때
- 특정 프로젝트 규칙을 기억하는 장기적 worker가 필요할 때
