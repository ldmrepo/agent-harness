# Hook 카테고리 분류
문서 ID: CC-HOOKS-CATEGORIES
버전: v1.1.0

## 1. 분류 원칙
Hook은 "언제 실행되는가"와 "무엇을 통제하는가"를 기준으로 분류한다.

## 2. 입력 통제 Hook
### 대상
- UserPromptSubmit
### 목적
- 금지 프롬프트 차단
- 프롬프트 전처리
- 추가 컨텍스트 주입

## 3. 도구 실행 통제 Hook
### 대상
- PreToolUse
- PermissionRequest
- PermissionDenied
### 목적
- 위험 명령 차단
- 승인 자동화
- 입력 수정
- defer 처리

## 4. 사후 검증 Hook
### 대상
- PostToolUse
- PostToolUseFailure
### 목적
- lint/test 실행
- 실패 피드백 주입
- MCP 결과 보정

## 5. 세션/컨텍스트 Hook
### 대상
- SessionStart
- InstructionsLoaded
- PreCompact
- PostCompact
- Stop
- StopFailure
- SessionEnd
### 목적
- 초기 컨텍스트 주입
- 규칙 로딩 감시
- compaction 전후 처리
- 종료 전후 제어

## 6. 작업/병렬 처리 Hook
### 대상
- SubagentStart
- SubagentStop
- TaskCreated
- TaskCompleted
- TeammateIdle
### 목적
- 품질 게이트
- teammate 중단 방지
- task naming/completion 정책

## 7. 환경/파일 반응 Hook
### 대상
- CwdChanged
- FileChanged
- ConfigChange
### 목적
- 환경변수 재적용
- 파일 감시
- 설정 변경 감사

## 8. 외부 상호작용 Hook
### 대상
- Notification
- Elicitation
- ElicitationResult
- WorktreeCreate
- WorktreeRemove
### 목적
- 시스템 알림
- MCP 사용자 입력 자동화
- 비-git worktree 처리
