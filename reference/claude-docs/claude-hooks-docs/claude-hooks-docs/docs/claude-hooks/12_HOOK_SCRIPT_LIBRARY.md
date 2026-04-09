# Hook Script Library
문서 ID: CC-HOOKS-SCRIPT-LIB
버전: v1.1.0

## 1. 개요
본 문서는 `.claude/hooks/` 아래에 저장하는 샘플 스크립트들의 목적과 동작을 설명한다.

## 2. 스크립트 목록
### 2.1 session-start-env.sh
- 이벤트: SessionStart
- 역할: 초기 환경변수와 프로젝트 컨텍스트 주입
- 차단 여부: 없음

### 2.2 block-dangerous-bash.sh
- 이벤트: PreToolUse
- 대상: Bash
- 역할: rm -rf 등 파괴적 명령 차단
- 차단 여부: 가능

### 2.3 protect-files.sh
- 이벤트: PreToolUse
- 대상: Edit|Write
- 역할: 민감 파일 편집 시 ask 처리
- 차단 여부: ask 또는 deny 가능

### 2.4 post-edit-lint.sh
- 이벤트: PostToolUse
- 대상: Edit|Write
- 역할: 수정 후 lint/test 비동기 수행
- 차단 여부: 비동기라 차단 불가

### 2.5 task-complete-test-gate.sh
- 이벤트: TaskCompleted
- 역할: 테스트 실패 시 task 완료 차단
- 차단 여부: 가능(exit 2)

### 2.6 cwd-env-refresh.sh
- 이벤트: CwdChanged
- 역할: 디렉토리 이동 시 환경 재설정
- 차단 여부: 없음

### 2.7 filechange-env-refresh.sh
- 이벤트: FileChanged
- 역할: 감시 파일 변경 후 환경 재적용
- 차단 여부: 없음

### 2.8 config-audit.sh
- 이벤트: ConfigChange
- 역할: 설정 변경 감사 로그 기록
- 차단 여부: 예시상 없음

### 2.9 stop-quality-gate.sh
- 이벤트: Stop
- 역할: 응답 종료 전 후속 작업 필요 여부 확인
- 차단 여부: 가능

### 2.10 notify.sh
- 이벤트: Notification
- 역할: OS 알림 전송
- 차단 여부: 없음
