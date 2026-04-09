# Hook Event Reference - Extended
문서 ID: CC-HOOKS-EVENT-EXT
버전: v1.1.0

## 1. Notification
Claude Code가 notification을 보낼 때 실행된다.
- permission_prompt
- idle_prompt
- auth_success
- elicitation_dialog

## 2. SubagentStart / SubagentStop
subagent 시작/종료 시 발화한다.
- subagent context 주입
- subagent 종료 품질 게이트

## 3. TaskCreated / TaskCompleted
task 생성/완료 시 정책을 강제한다.
- naming convention
- completion criteria
- 테스트 통과 여부 확인

## 4. Stop / StopFailure
- Stop: 정상 응답 완료 시
- StopFailure: API 오류 종료 시
Stop은 block으로 계속 작업시키는 것이 가능하다.
StopFailure는 관측용이다.

## 5. TeammateIdle
agent team teammate가 idle 상태로 가기 직전에 발화한다.
- teammate 재작업 유도
- 산출물 존재 검증

## 6. ConfigChange
설정 파일이 세션 중 변경될 때 발화한다.
- user_settings
- project_settings
- local_settings
- policy_settings
- skills
정책 설정(policy_settings)은 차단할 수 없다.

## 7. CwdChanged / FileChanged
- 디렉토리 이동 감지
- watch 파일 변경 감지
- CLAUDE_ENV_FILE 업데이트

## 8. WorktreeCreate / WorktreeRemove
기본 git worktree 동작을 대체하거나 정리한다.
- WorktreeCreate는 새 디렉토리 경로 반환 필수
- WorktreeRemove는 cleanup 용도

## 9. PreCompact / PostCompact
context compaction 전후에 발화한다.
- manual
- auto

## 10. Elicitation / ElicitationResult
MCP 서버가 사용자 입력을 요구할 때와 그 결과 처리 시점에 발화한다.
- accept / decline / cancel
- form content override 가능

## 11. SessionEnd
세션 종료 시 후처리 수행
- clear
- resume
- logout
- prompt_input_exit
- bypass_permissions_disabled
- other
