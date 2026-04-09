# Hook Lifecycle 및 실행 방식
문서 ID: CC-HOOKS-LIFECYCLE
버전: v1.1.0

## 1. 개요
Hook은 Claude Code lifecycle 상의 특정 event에서 발화한다.
event가 발생하고 matcher가 일치하면 Claude Code는 JSON context를 hook handler에 전달한다.

## 2. Hook lifecycle 주요 구간
### 2.1 세션 시작 구간
- SessionStart
- InstructionsLoaded

### 2.2 사용자 입력 구간
- UserPromptSubmit

### 2.3 도구 실행 구간
- PreToolUse
- PermissionRequest
- PermissionDenied
- PostToolUse
- PostToolUseFailure

### 2.4 에이전트/작업 구간
- SubagentStart
- SubagentStop
- TaskCreated
- TaskCompleted
- TeammateIdle

### 2.5 컨텍스트/세션 관리 구간
- PreCompact
- PostCompact
- Stop
- StopFailure
- SessionEnd

### 2.6 환경/파일 변화 구간
- CwdChanged
- FileChanged
- ConfigChange

### 2.7 외부 상호작용 구간
- Notification
- Elicitation
- ElicitationResult
- WorktreeCreate
- WorktreeRemove

## 3. 실행 흐름
1. event 발생
2. matcher group 평가
3. if 조건 평가(도구 이벤트에 한함)
4. hook handler 실행
5. exit code / HTTP 응답 / JSON output 해석
6. Claude Code가 허용, 차단, 수정, 후속 진행 여부 결정

## 4. 중요한 실행 규칙
- matcher가 맞지 않으면 handler는 실행되지 않는다
- tool event에서는 if 필드로 추가 필터링할 수 있다
- 동일 handler는 자동 dedupe될 수 있다
- async command hook은 백그라운드 실행되며 차단 제어를 할 수 없다
