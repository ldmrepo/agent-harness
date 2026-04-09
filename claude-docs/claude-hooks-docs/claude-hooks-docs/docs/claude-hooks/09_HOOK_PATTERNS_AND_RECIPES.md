# Hook 패턴 및 실전 레시피
문서 ID: CC-HOOKS-PATTERNS
버전: v1.1.0

## 1. 위험 Bash 차단
### 이벤트
PreToolUse
### 패턴
- matcher: Bash
- if: Bash(rm *)
### 목적
rm -rf 같은 파괴적 명령 차단

## 2. 수정 후 자동 lint
### 이벤트
PostToolUse
### matcher
Edit|Write
### 목적
파일 수정 후 자동 코드 스타일 검증

## 3. 세션 시작 시 환경 주입
### 이벤트
SessionStart
### 목적
프로젝트별 PATH/NODE_ENV 등 주입

## 4. 디렉토리 이동 시 환경 재설정
### 이벤트
CwdChanged
### 목적
direnv 유사 동작 구현

## 5. .envrc 변경 감지
### 이벤트
FileChanged
### matcher
.envrc|.env
### 목적
환경 캐시 갱신

## 6. 설정 파일 변경 감사
### 이벤트
ConfigChange
### 목적
project/local/user settings 변경 추적

## 7. task 완료 전 테스트 강제
### 이벤트
TaskCompleted
### 목적
테스트 미통과 task 완료 차단

## 8. Claude 정지 전 품질 게이트
### 이벤트
Stop
### 목적
"아직 할 일 있음" 판단 시 계속 작업

## 9. 비-git worktree 생성
### 이벤트
WorktreeCreate
### 목적
SVN/Perforce/Mercurial 환경 지원

## 10. MCP 사용자 입력 자동화
### 이벤트
Elicitation / ElicitationResult
### 목적
대화형 입력을 외부 시스템에서 대체
