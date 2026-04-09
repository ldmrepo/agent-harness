# Hook 타입별 설명
문서 ID: CC-HOOKS-TYPES
버전: v1.1.0

## 1. Command Hook
### 정의
shell command를 실행한다.
### 장점
- 빠름
- 로컬 도구 직접 사용 가능
- 결정론적
### 단점
- 보안 위험 높음
- 입력 검증 필요

## 2. HTTP Hook
### 정의
이벤트 JSON을 HTTP POST로 외부 서비스에 전달한다.
### 장점
- 중앙 정책 서버 연동 가능
- 팀 공용 검증 서비스 구성 가능
### 단점
- 네트워크 의존
- non-2xx는 비차단 오류

## 3. Prompt Hook
### 정의
빠른 Claude 모델에 단발성 평가를 요청한다.
### 출력 스키마
{ "ok": true|false, "reason": "..." }
### 장점
- 규칙을 코드 없이 작성 가능
- 가벼운 정책 판단에 적합
### 단점
- 실제 파일/코드 확인에는 약함

## 4. Agent Hook
### 정의
subagent를 띄워 도구를 사용하면서 검증한다.
### 장점
- Read/Grep/Glob 등으로 실제 코드 검증 가능
- 복합 조건 검사 가능
### 단점
- prompt hook보다 무거움
- timeout 관리 필요

## 5. Async Command Hook
### 정의
command hook에 async=true를 주어 백그라운드 실행한다.
### 특징
- 차단 제어 불가
- 다음 conversation turn에 결과 전달
### 적합 용도
- 테스트 실행
- 배포 후처리
- 알림 전송
