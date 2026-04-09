# Hook 운영, 보안, 트러블슈팅
문서 ID: CC-HOOKS-OPS
버전: v1.1.0

## 1. 운영 원칙
- Hook은 정책 게이트와 자동화 계층으로 본다
- CLAUDE.md로 해결할 수 없는 "항상 해야 하는 일"만 Hook으로 승격한다
- 차단 Hook과 관측 Hook을 분리한다

## 2. 보안 원칙
- command hook은 사용자 권한 전체로 실행됨
- 입력값은 절대 신뢰하지 않음
- shell 변수는 항상 quoting
- path traversal 차단
- 민감 파일(.env, .git, key)은 직접 처리 금지
- 절대 경로 사용

## 3. 성능 원칙
- SessionStart는 빠르게 유지
- 무거운 검증은 async 또는 agent hook으로 분리
- matcher/if로 불필요한 spawn 최소화

## 4. 디버깅
- claude --debug 사용
- CLAUDE_CODE_DEBUG_LOG_LEVEL=verbose 사용
- /hooks 메뉴에서 source/event/type 확인

## 5. 자주 발생하는 문제
### 5.1 Hook이 안 뜬다
- matcher 불일치
- if 조건 불일치
- 잘못된 settings 위치
- disableAllHooks 활성화

### 5.2 JSON 파싱 실패
- stdout에 JSON 외 텍스트 섞임
- shell profile 출력 섞임

### 5.3 차단이 안 된다
- exit 2 대신 exit 1 사용
- 차단 불가능한 event에 차단 로직 작성

### 5.4 Stop hook 무한 루프
- stop_hook_active 확인 누락
- 종료 조건 없이 계속 block

### 5.5 async hook 결과가 바로 안 보인다
- 다음 conversation turn에 전달되기 때문

## 6. 권장 운영 패턴
- PreToolUse: 정책 차단
- PostToolUse: 품질 검증
- SessionStart/CwdChanged/FileChanged: 환경 자동화
- ConfigChange/InstructionsLoaded: 감사 및 observability
