# 운영 / 보안 / 트러블슈팅
문서 ID: CC-ENV-OPS
버전: v1.0.0

## 1. 운영 원칙
- 자격증명은 shell secret store 또는 user scope env에 둔다
- project scope에는 비밀정보를 두지 않는다
- 기능 토글은 문제 분리 진단용으로 사용하고 상시 설정은 최소화한다
- reasoning / model / provider 조합은 함께 검증한다

## 2. 보안 원칙
- API key, OAuth token, provider credentials는 커밋 금지
- subprocess credential exposure를 줄이려면 CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1 검토
- OTel tool/prompt content logging은 기본 비활성 유지

## 3. 자주 발생하는 문제
### 3.1 API key가 구독 대신 사용됨
- ANTHROPIC_API_KEY 설정 여부 확인
- 구독 사용 원하면 unset

### 3.2 proxy 환경에서 MCP tool search 비활성
- ANTHROPIC_BASE_URL이 first-party가 아닌지 확인
- ENABLE_TOOL_SEARCH=true 검토

### 3.3 Bash export가 다음 명령에 안 남음
- 정상 동작
- CLAUDE_ENV_FILE 또는 hooks 사용

### 3.4 auto memory / CLAUDE.md 영향으로 결과가 달라짐
- CLAUDE_CODE_DISABLE_AUTO_MEMORY=1
- CLAUDE_CODE_DISABLE_CLAUDE_MDS=1 로 분리 진단

### 3.5 stream hang
- CLAUDE_ENABLE_STREAM_WATCHDOG=1
- CLAUDE_STREAM_IDLE_TIMEOUT_MS 조정

### 3.6 plugin이 첫 -p turn에서 안 보임
- CLAUDE_CODE_SYNC_PLUGIN_INSTALL=1 검토

## 4. 권장 표준 템플릿
- 개인 기본값: user settings env
- 프로젝트 기본값: non-secret, deterministic 항목만 project settings env
- 조직 공통: managed settings 또는 배포 셸 프로파일
