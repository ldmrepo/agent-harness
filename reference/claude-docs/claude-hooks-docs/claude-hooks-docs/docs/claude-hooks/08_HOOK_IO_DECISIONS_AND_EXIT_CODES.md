# Hook 입출력, 결정 제어, Exit Code
문서 ID: CC-HOOKS-IO
버전: v1.1.0

## 1. 공통 입력 필드
- session_id
- transcript_path
- cwd
- permission_mode
- hook_event_name

## 2. subagent 추가 입력
- agent_id
- agent_type

## 3. command hook 입력 방식
- stdin으로 JSON 수신

## 4. http hook 입력 방식
- POST body로 JSON 수신

## 5. exit code 의미
### 5.1 exit 0
- 성공
- stdout JSON 파싱 가능

### 5.2 exit 2
- blocking error
- stdout JSON 무시
- stderr 기반 차단/오류 처리

### 5.3 기타 exit code
- 대부분 non-blocking error
- 실행은 계속됨

## 6. JSON output 공통 필드
- continue
- stopReason
- suppressOutput
- systemMessage

## 7. decision control 패턴
### 7.1 top-level decision
대상:
- UserPromptSubmit
- PostToolUse
- PostToolUseFailure
- Stop
- SubagentStop
- ConfigChange

### 7.2 hookSpecificOutput.permissionDecision
대상:
- PreToolUse

### 7.3 hookSpecificOutput.decision
대상:
- PermissionRequest

### 7.4 retry
대상:
- PermissionDenied

## 8. continue=false
event와 무관하게 Claude 전체 진행을 멈춘다.

## 9. 중요한 운영 규칙
정책 강제 목적이라면 exit 1이 아니라 exit 2를 사용한다.
