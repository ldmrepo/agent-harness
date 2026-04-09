# 장시간 코딩 에이전트 하네스 변수 사전

## 문서 정보
- 문서명: 장시간 코딩 에이전트 하네스 변수 사전
- 문서 버전: v1.0-standard
- 작성일: 2026-04-07
- 목적: 고정된 하네스 구조에서 사용하는 프로젝트 의존 변수의 정의, 타입, 필수 여부, 예시값, 적용 파일을 표준화한다.

---

## 0. 문서 목적
본 문서는 장시간 코딩 에이전트 하네스 표준 문서에서 사용한 변수들의 의미를 일관되게 정의하기 위한 기준 문서이다.

이 문서의 목적은 다음과 같다.

1. 템플릿 치환 시 변수 의미의 혼선을 방지한다.
2. 동일한 변수를 여러 파일에서 일관되게 사용하게 한다.
3. 프로젝트 초기 세팅 시 어떤 값을 채워야 하는지 명확히 한다.
4. 필수 변수와 선택 변수를 구분한다.
5. 변수 타입과 예시를 제공한다.
6. 실제 저장소 주입 전 검토 체크리스트를 제공한다.

---

## 1. 변수 사용 원칙

### 1.1 구조 고정, 값만 치환
폴더/파일 구조는 고정하고, 프로젝트별 차이는 변수 치환으로 해결한다.

### 1.2 동일 의미, 동일 이름
동일 의미의 값은 문서와 스크립트 전반에서 같은 변수명을 사용한다.

### 1.3 하드코딩 금지
프로젝트명, 포트, 명령, 브랜치, 경로, 정책 플래그 등은 하드코딩하지 않는다.

### 1.4 타입 일관성 유지
- 문자열은 문자열로
- 불리언은 `true/false`
- 숫자는 숫자형으로
- 배열은 배열 구조로 유지한다.

### 1.5 필수 변수 우선 확정
최소 도입 단계에서는 필수 변수부터 먼저 확정한다.

---

## 2. 변수 분류 체계
본 문서에서는 변수를 다음 22개 그룹으로 구분한다.

1. 식별 변수
2. 런타임/기술 변수
3. 경로 변수
4. 명령 변수
5. 네트워크 변수
6. 정책 변수
7. 커밋/복구 변수
8. 문서/출력 변수
9. Bootstrap Enable 플래그
10. Bootstrap/State 파일명
11. Smoke 설정
12. Verify-All 설정
13. Commit 설정
14. Rollback 설정
15. Status 수집 설정
16. Session 변수
17. Task/Work Item 변수
18. Preflight/Post-Bootstrap 명령
19. 추가 환경/메타 변수
20. 에이전트 모델/색상 변수
21. Backlog/Known Issues 정책 변수
22. 인스턴스 번호 패턴

---

## 3. 식별 변수

### 3.1 `{{PROJECT_NAME}}`
- 의미: 프로젝트 표시명
- 타입: string
- 필수: 예
- 예시: `polymarket-strat-research`
- 사용처: 전 문서, 상태 파일, 에이전트/스킬 메타

### 3.2 `{{REPOSITORY_NAME}}`
- 의미: 저장소 루트 이름
- 타입: string
- 필수: 예
- 예시: `agent-harness-repo`
- 사용처: 구조 문서, 스크립트, 상태 파일

### 3.3 `{{HARNESS_TEMPLATE_VERSION}}`
- 의미: 템플릿 세트 버전
- 타입: string
- 필수: 예
- 예시: `v1.0-template`
- 사용처: 전 템플릿 메타

### 3.4 `{{CREATED_AT}}`
- 의미: 템플릿 또는 파일 생성 시각
- 타입: string(ISO 또는 정책 지정 형식)
- 필수: 예
- 예시: `2026-04-07T09:00:00+09:00`

### 3.5 `{{UPDATED_AT}}`
- 의미: 마지막 갱신 시각
- 타입: string
- 필수: 예
- 예시: `2026-04-07T10:30:00+09:00`

### 3.6 `{{DEFAULT_BRANCH}}`
- 의미: 기본 브랜치명
- 타입: string
- 필수: 예
- 예시: `main`

---

## 4. 런타임/기술 변수

### 4.1 `{{RUNTIME_TYPE}}`
- 의미: 프로젝트 런타임 유형
- 타입: string
- 필수: 예
- 권장값: `api`, `webapp`, `worker`, `monorepo`, `fullstack`

### 4.2 `{{PRIMARY_STACK}}`
- 의미: 주 기술 스택
- 타입: string
- 필수: 예
- 예시: `FastAPI + React + PostgreSQL`

### 4.3 `{{LANGUAGE_MAIN}}`
- 의미: 주 프로그래밍 언어
- 타입: string
- 필수: 권장
- 예시: `python`

### 4.4 `{{LANGUAGE_SECONDARY}}`
- 의미: 보조 언어
- 타입: string
- 필수: 아니오
- 예시: `typescript`

### 4.5 `{{PACKAGE_MANAGER}}`
- 의미: 패키지 매니저
- 타입: string
- 필수: 권장
- 예시: `pnpm`, `npm`, `poetry`, `uv`, `pip`

---

## 5. 경로 변수

### 5.1 `{{APP_DIR_NAME}}`
- 의미: 실제 앱 코드 루트 디렉터리명
- 타입: string
- 필수: 예
- 예시: `app`

### 5.2 `{{DOCS_DIR_NAME}}`
- 의미: 문서 디렉터리명
- 타입: string
- 필수: 예
- 예시: `docs`

### 5.3 `{{TASKS_DIR_NAME}}`
- 의미: 작업 상태 디렉터리명
- 타입: string
- 필수: 예
- 예시: `tasks`

### 5.4 `{{STATE_DIR_NAME}}`
- 의미: 상태 파일 디렉터리명
- 타입: string
- 필수: 예
- 예시: `state`

### 5.5 `{{LOG_DIR_NAME}}`
- 의미: 로그 디렉터리명
- 타입: string
- 필수: 예
- 예시: `.agent-logs`

### 5.6 `{{PID_DIR_NAME}}`
- 의미: PID 파일 디렉터리명
- 타입: string
- 필수: 예
- 예시: `.agent-pids`

### 5.7 `{{AGENTS_FILE_PATH}}`
- 의미: AGENTS.md 파일의 상대 경로
- 타입: string
- 필수: 예
- 예시: `AGENTS.md`

### 5.8 `{{ENVIRONMENT_FILE_PATH}}`
- 의미: 환경 설정 파일의 상대 경로
- 타입: string
- 필수: 예
- 예시: `state/environment.json`

### 5.9 `{{PROGRESS_FILE_PATH}}`
- 의미: 진행 상태 파일의 상대 경로
- 타입: string
- 필수: 예
- 예시: `claude-progress.txt`

### 5.10 `{{FEATURE_LIST_FILE_PATH}}`
- 의미: 기능 목록 파일의 상대 경로
- 타입: string
- 필수: 예
- 예시: `feature_list.json`

### 5.11 `{{CURRENT_TASK_FILE_PATH}}`
- 의미: 현재 작업 파일의 상대 경로
- 타입: string
- 필수: 예
- 예시: `tasks/current_task.json`

### 5.12 `{{BACKLOG_FILE_PATH}}`
- 의미: 백로그 파일의 상대 경로
- 타입: string
- 필수: 예
- 예시: `tasks/backlog.json`

### 5.13 `{{KNOWN_ISSUES_FILE_PATH}}`
- 의미: 알려진 이슈 파일의 상대 경로
- 타입: string
- 필수: 예
- 예시: `state/known_issues.json`

### 5.14 `{{SESSION_SUMMARY_FILE_PATH}}`
- 의미: 세션 요약 파일의 상대 경로
- 타입: string
- 필수: 예
- 예시: `state/session_summary.json`

### 5.15 `{{SMOKE_SCRIPT_PATH}}`
- 의미: 스모크 테스트 스크립트의 상대 경로
- 타입: string
- 필수: 예
- 예시: `verification/smoke.sh`

### 5.16 `{{VERIFY_ALL_SCRIPT_PATH}}`
- 의미: 전체 검증 스크립트의 상대 경로
- 타입: string
- 필수: 예
- 예시: `verification/verify_all.sh`

### 5.17 `{{INIT_SCRIPT_PATH}}`
- 의미: 초기화 스크립트의 상대 경로
- 타입: string
- 필수: 예
- 예시: `init.sh`

---

## 6. 명령 변수

### 6.1 Bootstrap 계열
- `{{CMD_BOOTSTRAP}}`
  - 의미: bootstrap 진입 명령
  - 예시: `bash ./init.sh`

- `{{CMD_INSTALL}}`
  - 의미: 의존성 설치 명령
  - 예시: `pnpm install`

- `{{CMD_INFRA_UP}}`
  - 의미: 로컬 인프라 기동 명령
  - 예시: `docker compose up -d postgres redis`

- `{{CMD_DB_MIGRATE}}`
  - 의미: DB 마이그레이션 명령
  - 예시: `pnpm db:migrate`

- `{{CMD_DEV}}`
  - 의미: 앱 실행 명령
  - 예시: `pnpm dev`

- `{{CMD_WORKER}}`
  - 의미: 백그라운드 워커 실행 명령
  - 예시: `python -m app.worker`

### 6.2 Verification 계열
- `{{CMD_SMOKE}}`
  - 의미: smoke 검증 명령
  - 예시: `bash ./verification/smoke.sh`

- `{{CMD_VERIFY_ALL}}`
  - 의미: 전체 검증 명령
  - 예시: `bash ./verification/verify_all.sh`

- `{{CMD_LINT}}`
  - 의미: lint 명령
  - 예시: `pnpm lint`

- `{{CMD_TYPECHECK}}`
  - 의미: 타입 점검 명령
  - 예시: `pnpm typecheck`

- `{{CMD_TEST_UNIT}}`
  - 의미: 단위 테스트 명령
  - 예시: `pytest tests/unit -q`

- `{{CMD_TEST_INTEGRATION}}`
  - 의미: 통합 테스트 명령
  - 예시: `pytest tests/integration -q`

- `{{CMD_TEST_E2E}}`
  - 의미: E2E 테스트 명령
  - 예시: `pnpm test:e2e`

- `{{CMD_COLLECT_STATUS}}`
  - 의미: 상태 수집 명령
  - 예시: `bash ./scripts/collect_status.sh`

### 6.3 선택적 추가 명령

다음은 선택적으로 사용하는 추가 검증/테스트 명령 변수이다.

### 6.4 `{{CMD_SCHEMA_CHECK}}`
- 의미: 스키마/계약 검사 명령
- 타입: string
- 필수: 아니오
- 예시: `pnpm schema:check`

### 6.5 `{{CMD_SECURITY_CHECK}}`
- 의미: 보안 검사 명령
- 타입: string
- 필수: 아니오
- 예시: `npm audit`

### 6.6 `{{CMD_PERF_SMOKE}}`
- 의미: 성능 스모크 테스트 명령
- 타입: string
- 필수: 아니오
- 예시: `pnpm perf:smoke`

### 6.7 `{{CMD_TEST_GATE_EXTRA_1}}`
- 의미: 추가 테스트 게이트 명령 1
- 타입: string
- 필수: 아니오

### 6.8 `{{CMD_TEST_GATE_EXTRA_2}}`
- 의미: 추가 테스트 게이트 명령 2
- 타입: string
- 필수: 아니오

### 6.9 `{{CMD_REGRESSION_CHECK_1}}`
- 의미: 회귀 검사 명령 1
- 타입: string
- 필수: 아니오

### 6.10 `{{CMD_REGRESSION_CHECK_2}}`
- 의미: 회귀 검사 명령 2
- 타입: string
- 필수: 아니오

### 6.11 `{{CMD_REGRESSION_CHECK_3}}`
- 의미: 회귀 검사 명령 3
- 타입: string
- 필수: 아니오

이 변수들은 해당 검증을 실제로 운영할 때만 채운다.

---

## 7. 네트워크 변수

### 7.1 앱/서비스 접속 정보
- `{{APP_HOST}}` 예: `localhost`
- `{{APP_PORT}}` 예: `3000`
- `{{API_HOST}}` 예: `localhost`
- `{{API_PORT}}` 예: `8000`
- `{{DB_HOST}}` 예: `localhost`
- `{{DB_PORT}}` 예: `5432`
- `{{CACHE_HOST}}` 예: `localhost`
- `{{CACHE_PORT}}` 예: `6379`

### 7.2 `{{HEALTHCHECK_URL}}`
- 의미: baseline readiness 확인용 URL
- 타입: string
- 필수: healthcheck 사용하는 경우 예
- 예시: `http://localhost:8000/health`

---

## 8. 정책 변수

### 8.1 `{{ALLOW_PARALLEL_TASKS}}`
- 의미: 한 세션에서 여러 작업 병행 허용 여부
- 타입: boolean
- 필수: 예
- 권장 기본값: `false`

### 8.2 `{{REQUIRE_REVIEW_AGENT}}`
- 의미: 최종 approval 전에 reviewer 역할 필수 여부
- 타입: boolean
- 필수: 예
- 권장 기본값: `true`

### 8.3 `{{REQUIRE_FULL_VERIFY_FOR_CORE_CHANGE}}`
- 의미: core/shared 변경 시 verify_all 강제 여부
- 타입: boolean
- 필수: 예
- 권장 기본값: `true`

### 8.4 `{{ALLOW_AUTO_COMMIT}}`
- 의미: 세션 종료 시 자동 커밋 허용 여부
- 타입: boolean
- 필수: 예
- 권장 기본값: `false` 또는 팀 정책값

### 8.5 `{{SESSION_MAX_SCOPE}}`
- 의미: 세션당 허용 범위 설명값
- 타입: string
- 필수: 예
- 예시: `single bounded feature or bugfix with limited file spread`

### 8.6 Regression 임계값
- `{{REGRESSION_RISK_THRESHOLD_FOR_REJECTION}}`
- `{{REGRESSION_RISK_THRESHOLD_FOR_PENDING}}`

예시:
- rejection: `high`
- pending: `medium`

---

## 9. 커밋 / 복구 변수

### 9.1 Commit Prefix 변수
- `{{COMMIT_PREFIX_FEAT}}` 예: `feat`
- `{{COMMIT_PREFIX_FIX}}` 예: `fix`
- `{{COMMIT_PREFIX_CHORE}}` 예: `chore`

### 9.2 Rollback 변수
- `{{ROLLBACK_TARGET_COMMIT}}`
  - 의미: 복구 시 기본 대상 ref/commit
  - 예시: `HEAD~1`

- `{{ROLLBACK_REASON}}`
  - 의미: 기본 복구 사유 문자열
  - 예시: `restore last known good state after failed session`

- `{{ROLLBACK_MODE}}`
  - 의미: rollback 모드
  - 권장값: `soft`, `mixed`, `hard`

---

## 10. 문서 / 리포트 변수

### 10.1 문서 버전 변수
- `{{ARCHITECTURE_DOC_VERSION}}`
- `{{RUNBOOK_DOC_VERSION}}`
- `{{QUALITY_GATES_DOC_VERSION}}`

### 10.2 리포트 파일명 변수 예시
- `{{SMOKE_REPORT_FILENAME}}` 예: `smoke_report.json`
- `{{VERIFY_ALL_REPORT_FILENAME}}` 예: `verify_all_report.json`
- `{{STATUS_REPORT_FILENAME}}` 예: `status_report.json`

---

## 11. Bootstrap Enable 플래그

Bootstrap 과정의 각 단계를 활성화/비활성화하는 불리언 플래그 변수이다. `init.sh` 및 `scripts/bootstrap_env.sh`에서 사용한다.

### 11.1 `{{BOOTSTRAP_ENABLE_INSTALL}}`
- 의미: 의존성 설치 단계 활성화 여부
- 타입: boolean
- 필수: 예
- 예시: `true`
- 사용처: init.sh, bootstrap_env.sh, environment.json

### 11.2 `{{BOOTSTRAP_ENABLE_INFRA}}`
- 의미: 로컬 인프라(Docker 등) 기동 단계 활성화 여부
- 타입: boolean
- 필수: 예
- 예시: `false`
- 사용처: init.sh, bootstrap_env.sh, environment.json

### 11.3 `{{BOOTSTRAP_ENABLE_DB_MIGRATE}}`
- 의미: 데이터베이스 마이그레이션 단계 활성화 여부
- 타입: boolean
- 필수: 예
- 예시: `false`
- 사용처: init.sh, bootstrap_env.sh, environment.json

### 11.4 `{{BOOTSTRAP_ENABLE_PREFLIGHT}}`
- 의미: 사전 점검(preflight) 명령 실행 단계 활성화 여부
- 타입: boolean
- 필수: 예
- 예시: `false`
- 사용처: init.sh, bootstrap_env.sh

### 11.5 `{{BOOTSTRAP_ENABLE_APP_START}}`
- 의미: 앱 프로세스 자동 기동 단계 활성화 여부
- 타입: boolean
- 필수: 예
- 예시: `true`
- 사용처: init.sh, bootstrap_env.sh, environment.json

### 11.6 `{{BOOTSTRAP_ENABLE_WORKER_START}}`
- 의미: 백그라운드 워커 프로세스 기동 단계 활성화 여부
- 타입: boolean
- 필수: 예
- 예시: `false`
- 사용처: init.sh, bootstrap_env.sh, environment.json

### 11.7 `{{BOOTSTRAP_ENABLE_HEALTHCHECK}}`
- 의미: 부트스트랩 완료 후 헬스체크 실행 여부
- 타입: boolean
- 필수: 예
- 예시: `true`
- 사용처: init.sh, bootstrap_env.sh, environment.json

### 11.8 `{{BOOTSTRAP_ENABLE_POST_BOOTSTRAP}}`
- 의미: 부트스트랩 이후 추가 후속 명령 실행 단계 활성화 여부
- 타입: boolean
- 필수: 예
- 예시: `false`
- 사용처: init.sh, bootstrap_env.sh

### 11.9 `{{BOOTSTRAP_WAIT_SECONDS}}`
- 의미: 서비스 안정화 대기 시간(초)
- 타입: number
- 필수: 권장
- 예시: `5`
- 사용처: init.sh, bootstrap_env.sh, environment.json

---

## 12. Bootstrap/State 파일명

로그 파일, 상태 파일, PID 파일 등의 파일명을 지정하는 변수이다. 디렉터리 경로가 아닌 파일명만 지정한다.

### 12.1 `{{BOOTSTRAP_LOG_FILENAME}}`
- 의미: 부트스트랩 실행 로그 파일명
- 타입: string
- 필수: 권장
- 예시: `bootstrap.log`
- 사용처: bootstrap_env.sh

### 12.2 `{{BOOTSTRAP_STATE_FILENAME}}`
- 의미: 부트스트랩 상태 결과 파일명
- 타입: string
- 필수: 권장
- 예시: `bootstrap_state.json`
- 사용처: bootstrap_env.sh

### 12.3 `{{APP_LOG_FILENAME}}`
- 의미: 앱 프로세스 stdout/stderr 로그 파일명
- 타입: string
- 필수: 권장
- 예시: `app.log`
- 사용처: init.sh, bootstrap_env.sh

### 12.4 `{{APP_PID_FILENAME}}`
- 의미: 앱 프로세스 PID 파일명
- 타입: string
- 필수: 권장
- 예시: `app.pid`
- 사용처: init.sh, bootstrap_env.sh, collect_status.sh

### 12.5 `{{WORKER_LOG_FILENAME}}`
- 의미: 워커 프로세스 stdout/stderr 로그 파일명
- 타입: string
- 필수: 아니오
- 예시: `worker.log`
- 사용처: init.sh, bootstrap_env.sh

### 12.6 `{{WORKER_PID_FILENAME}}`
- 의미: 워커 프로세스 PID 파일명
- 타입: string
- 필수: 아니오
- 예시: `worker.pid`
- 사용처: init.sh, bootstrap_env.sh, collect_status.sh

### 12.7 `{{COMMIT_LOG_FILENAME}}`
- 의미: 커밋 세션 실행 로그 파일명
- 타입: string
- 필수: 권장
- 예시: `commit_session.log`
- 사용처: commit_session.sh

### 12.8 `{{COMMIT_STATE_FILENAME}}`
- 의미: 커밋 세션 상태 결과 파일명
- 타입: string
- 필수: 권장
- 예시: `commit_state.json`
- 사용처: commit_session.sh

---

## 13. Smoke 설정

`verification/smoke.sh`에서 사용하는 스모크 테스트 단계별 활성화 플래그 및 설정 변수이다.

### 27.1 `{{SMOKE_ENABLE_PRECHECKS}}`
- 의미: 스모크 사전 점검 명령 실행 활성화 여부
- 타입: boolean
- 필수: 권장
- 예시: `false`
- 사용처: smoke.sh

### 27.2 `{{SMOKE_ENABLE_PROCESS_CHECK}}`
- 의미: 프로세스 존재 확인 단계 활성화 여부
- 타입: boolean
- 필수: 권장
- 예시: `true`
- 사용처: smoke.sh

### 27.3 `{{SMOKE_ENABLE_PORT_CHECK}}`
- 의미: 포트 도달 가능 확인 단계 활성화 여부
- 타입: boolean
- 필수: 권장
- 예시: `true`
- 사용처: smoke.sh

### 27.4 `{{SMOKE_ENABLE_HEALTHCHECK}}`
- 의미: 스모크 중 헬스체크 URL 확인 활성화 여부
- 타입: boolean
- 필수: 권장
- 예시: `true`
- 사용처: smoke.sh

### 27.5 `{{SMOKE_ENABLE_API_PROBE}}`
- 의미: API 프로브(probe) URL 확인 활성화 여부
- 타입: boolean
- 필수: 아니오
- 예시: `false`
- 사용처: smoke.sh

### 27.6 `{{SMOKE_ENABLE_UI_PROBE}}`
- 의미: UI 프로브 명령 실행 활성화 여부
- 타입: boolean
- 필수: 아니오
- 예시: `false`
- 사용처: smoke.sh

### 13.7 `{{SMOKE_ENABLE_CUSTOM_CHECKS}}`
- 의미: 사용자 정의 스모크 검사 명령 활성화 여부
- 타입: boolean
- 필수: 아니오
- 예시: `false`
- 사용처: smoke.sh

### 13.8 `{{SMOKE_TARGET_HOST}}`
- 의미: 스모크 포트 검사 대상 호스트
- 타입: string
- 필수: 포트 검사 사용 시 예
- 예시: `localhost`
- 사용처: smoke.sh

### 13.9 `{{SMOKE_TARGET_PORT}}`
- 의미: 스모크 포트 검사 대상 포트 번호
- 타입: string
- 필수: 포트 검사 사용 시 예
- 예시: `3000`
- 사용처: smoke.sh

### 27.10 `{{SMOKE_API_PROBE_URL}}`
- 의미: API 프로브 대상 URL
- 타입: string
- 필수: API 프로브 사용 시 예
- 예시: `http://localhost:8000/api/v1/status`
- 사용처: smoke.sh

### 27.11 `{{SMOKE_UI_PROBE_COMMAND}}`
- 의미: UI 프로브 실행 명령
- 타입: string
- 필수: UI 프로브 사용 시 예
- 예시: `curl -fsS http://localhost:3000 | grep -q '<html'`
- 사용처: smoke.sh

### 27.12 `{{SMOKE_RESULT_PLACEHOLDER}}`
- 의미: 스모크 리포트 JSON 내 결과 치환용 플레이스홀더 문자열
- 타입: string
- 필수: 예 (템플릿 내부용)
- 예시: `__SMOKE_RESULT__`
- 사용처: smoke.sh (내부 sed 치환)

### 27.13 `{{PROCESS_MATCH_PATTERN}}`
- 의미: 프로세스 존재 확인 시 pgrep -f에 사용할 패턴
- 타입: string
- 필수: 프로세스 검사 사용 시 예
- 예시: `node.*server.js`
- 사용처: smoke.sh

### 27.14 `{{CMD_SMOKE_PRECHECK_1}}`
- 의미: 스모크 사전 점검 명령 1
- 타입: string
- 필수: 아니오
- 예시: `test -f .env`
- 사용처: smoke.sh

### 27.15 `{{CMD_SMOKE_PRECHECK_2}}`
- 의미: 스모크 사전 점검 명령 2
- 타입: string
- 필수: 아니오
- 사용처: smoke.sh

### 27.16 `{{CMD_SMOKE_CUSTOM_1}}`
- 의미: 사용자 정의 스모크 검사 명령 1
- 타입: string
- 필수: 아니오
- 예시: `pnpm test:smoke:custom`
- 사용처: smoke.sh

### 27.17 `{{CMD_SMOKE_CUSTOM_2}}`
- 의미: 사용자 정의 스모크 검사 명령 2
- 타입: string
- 필수: 아니오
- 사용처: smoke.sh

### 27.18 `{{CMD_SMOKE_CUSTOM_3}}`
- 의미: 사용자 정의 스모크 검사 명령 3
- 타입: string
- 필수: 아니오
- 사용처: smoke.sh

### 27.19 `{{REQUIRED_FILE_1}}`
- 의미: 스모크에서 존재 확인할 필수 파일 경로 1 (루트 기준 상대 경로)
- 타입: string
- 필수: 아니오
- 예시: `package.json`
- 사용처: smoke.sh

### 27.20 `{{REQUIRED_FILE_2}}`
- 의미: 스모크에서 존재 확인할 필수 파일 경로 2
- 타입: string
- 필수: 아니오
- 예시: `state/environment.json`
- 사용처: smoke.sh

### 27.21 `{{REQUIRED_FILE_3}}`
- 의미: 스모크에서 존재 확인할 필수 파일 경로 3
- 타입: string
- 필수: 아니오
- 사용처: smoke.sh

### 27.22 `{{REQUIRED_FILE_4}}`
- 의미: 스모크에서 존재 확인할 필수 파일 경로 4
- 타입: string
- 필수: 아니오
- 사용처: smoke.sh

---

## 14. Verify-All 설정

`verification/verify_all.sh`에서 사용하는 전체 검증 단계별 활성화 플래그 및 설정 변수이다.

### 14.1 `{{VERIFY_ENABLE_LINT}}`
- 의미: lint 검사 단계 활성화 여부
- 타입: boolean
- 필수: 권장
- 예시: `true`
- 사용처: verify_all.sh, environment.json

### 14.2 `{{VERIFY_ENABLE_TYPECHECK}}`
- 의미: 타입 검사 단계 활성화 여부
- 타입: boolean
- 필수: 권장
- 예시: `true`
- 사용처: verify_all.sh, environment.json

### 14.3 `{{VERIFY_ENABLE_UNIT}}`
- 의미: 단위 테스트 단계 활성화 여부
- 타입: boolean
- 필수: 권장
- 예시: `true`
- 사용처: verify_all.sh, environment.json

### 14.4 `{{VERIFY_ENABLE_INTEGRATION}}`
- 의미: 통합 테스트 단계 활성화 여부
- 타입: boolean
- 필수: 권장
- 예시: `false`
- 사용처: verify_all.sh, environment.json

### 14.5 `{{VERIFY_ENABLE_E2E}}`
- 의미: E2E 테스트 단계 활성화 여부
- 타입: boolean
- 필수: 권장
- 예시: `false`
- 사용처: verify_all.sh, environment.json

### 14.6 `{{VERIFY_ENABLE_BUILD}}`
- 의미: 빌드 검사 단계 활성화 여부
- 타입: boolean
- 필수: 권장
- 예시: `true`
- 사용처: verify_all.sh, environment.json

### 14.7 `{{VERIFY_ENABLE_SCHEMA_CHECK}}`
- 의미: 스키마/계약 검사 단계 활성화 여부
- 타입: boolean
- 필수: 아니오
- 예시: `false`
- 사용처: verify_all.sh, environment.json

### 14.8 `{{VERIFY_ENABLE_SECURITY_CHECK}}`
- 의미: 보안 검사 단계 활성화 여부
- 타입: boolean
- 필수: 아니오
- 예시: `false`
- 사용처: verify_all.sh, environment.json

### 14.9 `{{VERIFY_ENABLE_PERF_SMOKE}}`
- 의미: 성능 스모크 검사 단계 활성화 여부
- 타입: boolean
- 필수: 아니오
- 예시: `false`
- 사용처: verify_all.sh, environment.json

### 14.10 `{{VERIFY_ENABLE_CUSTOM_CHECKS}}`
- 의미: 사용자 정의 검증 명령 단계 활성화 여부
- 타입: boolean
- 필수: 아니오
- 예시: `false`
- 사용처: verify_all.sh

### 14.11 `{{VERIFY_ENABLE_REVIEW_GATE_HOOK}}`
- 의미: 리뷰 게이트 훅 실행 활성화 여부
- 타입: boolean
- 필수: 아니오
- 예시: `false`
- 사용처: verify_all.sh

### 14.12 `{{VERIFY_ALL_RUN_SMOKE_FIRST}}`
- 의미: 전체 검증 시작 전 스모크 검증을 먼저 실행할지 여부
- 타입: boolean
- 필수: 권장
- 예시: `true`
- 사용처: verify_all.sh, environment.json

### 14.13 `{{VERIFY_ALL_RESULT_PLACEHOLDER}}`
- 의미: verify_all 리포트 JSON 내 결과 치환용 플레이스홀더 문자열
- 타입: string
- 필수: 예 (템플릿 내부용)
- 예시: `__VERIFY_ALL_RESULT__`
- 사용처: verify_all.sh (내부 sed 치환)

### 14.14 `{{CMD_VERIFY_CUSTOM_1}}`
- 의미: 사용자 정의 전체 검증 명령 1
- 타입: string
- 필수: 아니오
- 예시: `pnpm test:custom`
- 사용처: verify_all.sh

### 14.15 `{{CMD_VERIFY_CUSTOM_2}}`
- 의미: 사용자 정의 전체 검증 명령 2
- 타입: string
- 필수: 아니오
- 사용처: verify_all.sh

### 14.16 `{{CMD_VERIFY_CUSTOM_3}}`
- 의미: 사용자 정의 전체 검증 명령 3
- 타입: string
- 필수: 아니오
- 사용처: verify_all.sh

### 14.17 `{{CMD_REVIEW_GATE_HOOK}}`
- 의미: 리뷰 게이트 훅 명령 (검증 파이프라인 마지막 단계에서 실행)
- 타입: string
- 필수: 아니오
- 예시: `bash ./scripts/review_gate.sh`
- 사용처: verify_all.sh

### 14.18 `{{CMD_BUILD}}`
- 의미: 프로젝트 빌드 명령
- 타입: string
- 필수: 빌드 검사 사용 시 예
- 예시: `pnpm build`
- 사용처: verify_all.sh, environment.json

---

## 15. Commit 설정

`scripts/commit_session.sh`에서 사용하는 커밋 세션 동작 제어 변수이다.

### 15.1 `{{COMMIT_REQUIRE_CLEAN_STATE_FLAG}}`
- 의미: 커밋 전 세션 요약의 clean_state 플래그 확인 필수 여부
- 타입: boolean
- 필수: 권장
- 예시: `true`
- 사용처: commit_session.sh

### 15.2 `{{COMMIT_STAGE_ALL}}`
- 의미: 모든 변경 파일을 git add -A로 스테이징할지 여부 (false이면 개별 경로만 스테이징)
- 타입: boolean
- 필수: 예
- 예시: `false`
- 사용처: commit_session.sh

### 15.3 `{{COMMIT_STAGE_PATH_1}}`
- 의미: 개별 스테이징 대상 경로 1
- 타입: string
- 필수: 아니오
- 예시: `app/`
- 사용처: commit_session.sh

### 15.4 `{{COMMIT_STAGE_PATH_2}}`
- 의미: 개별 스테이징 대상 경로 2
- 타입: string
- 필수: 아니오
- 예시: `state/`
- 사용처: commit_session.sh

### 15.5 `{{COMMIT_STAGE_PATH_3}}`
- 의미: 개별 스테이징 대상 경로 3
- 타입: string
- 필수: 아니오
- 예시: `tasks/`
- 사용처: commit_session.sh

### 15.6 `{{COMMIT_STAGE_PATH_4}}`
- 의미: 개별 스테이징 대상 경로 4
- 타입: string
- 필수: 아니오
- 예시: `claude-progress.txt`
- 사용처: commit_session.sh

### 15.7 `{{FALLBACK_TASK_ID}}`
- 의미: WORK_ITEM_ID가 비어 있을 때 사용할 대체 작업 ID
- 타입: string
- 필수: 권장
- 예시: `harness`
- 사용처: commit_session.sh

### 15.8 `{{FALLBACK_COMMIT_SUMMARY}}`
- 의미: COMMIT_MESSAGE_SUMMARY가 비어 있을 때 사용할 대체 커밋 메시지
- 타입: string
- 필수: 권장
- 예시: `session work`
- 사용처: commit_session.sh

### 15.9 `{{COMMIT_MESSAGE_SUMMARY}}`
- 의미: 커밋 메시지의 요약 문자열 (세션 종료 시 구성)
- 타입: string
- 필수: 예 (세션 종료 시)
- 예시: `implement user login API endpoint`
- 사용처: commit_session.sh, coder.md

---

## 16. Rollback 설정

`scripts/rollback_last_good.sh`에서 사용하는 롤백 동작 제어 변수이다.

### 16.1 `{{ROLLBACK_ENABLED}}`
- 의미: 롤백 기능 전체 활성화 여부
- 타입: boolean
- 필수: 예
- 예시: `true`
- 사용처: rollback_last_good.sh

### 16.2 `{{ROLLBACK_REQUIRE_CLEAN_WORKTREE}}`
- 의미: 롤백 실행 전 워킹 트리 clean 상태 필수 여부
- 타입: boolean
- 필수: 권장
- 예시: `true`
- 사용처: rollback_last_good.sh

### 16.3 `{{ROLLBACK_TARGET_COMMIT}}`
- 의미: 롤백 대상 기본 커밋 ref
- 타입: string
- 필수: 아니오 (CLI 인자 또는 fallback ref로 대체 가능)
- 예시: `HEAD~1`
- 사용처: rollback_last_good.sh

### 16.4 `{{ROLLBACK_REASON}}`
- 의미: 롤백 기본 사유 문자열
- 타입: string
- 필수: 아니오
- 예시: `restore last known good state after failed session`
- 사용처: rollback_last_good.sh

### 16.5 `{{ROLLBACK_MODE}}`
- 의미: git reset 모드
- 타입: string
- 필수: 예
- 권장값: `soft`, `mixed`, `hard`
- 예시: `hard`
- 사용처: rollback_last_good.sh

### 16.6 `{{ROLLBACK_CLEAN_UNTRACKED}}`
- 의미: 롤백 후 미추적 파일 삭제(git clean -fd) 여부
- 타입: boolean
- 필수: 권장
- 예시: `false`
- 사용처: rollback_last_good.sh

### 16.7 `{{ROLLBACK_RUN_SMOKE_AFTER}}`
- 의미: 롤백 완료 후 스모크 검증 실행 여부
- 타입: boolean
- 필수: 권장
- 예시: `true`
- 사용처: rollback_last_good.sh

### 16.8 `{{ROLLBACK_RUN_STATUS_COLLECT}}`
- 의미: 롤백 완료 후 상태 수집 실행 여부
- 타입: boolean
- 필수: 권장
- 예시: `true`
- 사용처: rollback_last_good.sh

### 16.9 `{{ROLLBACK_FALLBACK_REF}}`
- 의미: ROLLBACK_TARGET_COMMIT이 지정되지 않았을 때 사용할 대체 git ref
- 타입: string
- 필수: 아니오
- 예시: `origin/main`
- 사용처: rollback_last_good.sh

### 16.10 `{{ROLLBACK_LOG_FILENAME}}`
- 의미: 롤백 실행 로그 파일명
- 타입: string
- 필수: 권장
- 예시: `rollback.log`
- 사용처: rollback_last_good.sh

### 16.11 `{{ROLLBACK_STATE_FILENAME}}`
- 의미: 롤백 상태 결과 파일명
- 타입: string
- 필수: 권장
- 예시: `rollback_state.json`
- 사용처: rollback_last_good.sh

---

## 17. Status 수집 설정

`scripts/collect_status.sh`에서 사용하는 상태 수집 관련 변수이다.

### 17.1 `{{STATUS_ENABLE_HEALTHCHECK}}`
- 의미: 상태 수집 시 헬스체크 URL 확인 활성화 여부
- 타입: boolean
- 필수: 권장
- 예시: `true`
- 사용처: collect_status.sh

### 17.2 `{{STATUS_ENABLE_PORT_CHECK}}`
- 의미: 상태 수집 시 포트 도달 가능 확인 활성화 여부
- 타입: boolean
- 필수: 권장
- 예시: `true`
- 사용처: collect_status.sh

### 17.3 `{{STATUS_TARGET_HOST}}`
- 의미: 상태 수집 포트 검사 대상 호스트
- 타입: string
- 필수: 포트 검사 사용 시 예
- 예시: `localhost`
- 사용처: collect_status.sh

### 17.4 `{{STATUS_TARGET_PORT}}`
- 의미: 상태 수집 포트 검사 대상 포트 번호
- 타입: string
- 필수: 포트 검사 사용 시 예
- 예시: `8000`
- 사용처: collect_status.sh

### 17.5 `{{STATUS_LOG_FILENAME}}`
- 의미: 상태 수집 실행 로그 파일명
- 타입: string
- 필수: 권장
- 예시: `collect_status.log`
- 사용처: collect_status.sh

### 17.6 `{{STATUS_REPORT_FILENAME}}`
- 의미: 상태 수집 결과 리포트 파일명
- 타입: string
- 필수: 예
- 예시: `status_report.json`
- 사용처: collect_status.sh

---

## 18. Session 변수

세션 식별, 타임스탬프, 브랜치 관련 변수이다. `claude-progress.txt`, `session_summary.json`, `current_task.json` 등에서 사용한다.

### 18.1 `{{SESSION_ID}}`
- 의미: 현재 세션의 고유 식별자
- 타입: string
- 필수: 예
- 예시: `session-2026-04-07-001`
- 사용처: claude-progress.txt, session_summary.json, current_task.json

### 18.2 `{{SESSION_TYPE}}`
- 의미: 세션 유형
- 타입: string
- 필수: 예
- 권장값: `planner`, `initializer`, `coding`, `reviewer`, `recovery`, `maintenance`
- 예시: `coding`
- 사용처: claude-progress.txt, session_summary.json, current_task.json

### 18.3 `{{SESSION_TIMESTAMP}}`
- 의미: 세션 진행 기록용 타임스탬프 (progress 블록 헤더)
- 타입: string
- 필수: 예
- 예시: `2026-04-07T10:30:00+09:00`
- 사용처: claude-progress.txt

### 18.4 `{{CURRENT_BRANCH}}`
- 의미: 현재 작업 브랜치명
- 타입: string
- 필수: 예
- 예시: `feat/login-api`
- 사용처: collect_status.sh, commit_session.sh, rollback_last_good.sh, session_summary.json, current_task.json, environment.json

### 18.5 `{{CURRENT_BRANCH_FALLBACK}}`
- 의미: git rev-parse 실패 시 사용할 대체 브랜치명
- 타입: string
- 필수: 권장
- 예시: `unknown`
- 사용처: collect_status.sh, commit_session.sh, rollback_last_good.sh

### 18.6 `{{CURRENT_COMMIT}}`
- 의미: 현재 HEAD 커밋 해시
- 타입: string
- 필수: 예
- 예시: `abc1234567890def`
- 사용처: environment.json

---

## 19. Task/Work Item 변수

작업 항목 식별 및 상태 관련 변수이다. `current_task.json`, `commit_session.sh`, `session_summary.json`, `claude-progress.txt` 등에서 사용한다.

### 19.1 `{{WORK_ITEM_ID}}`
- 의미: 현재 선택된 작업 항목의 고유 ID
- 타입: string
- 필수: 예
- 예시: `F-001`
- 사용처: commit_session.sh, session_summary.json, current_task.json, claude-progress.txt, planner.md, coder.md, reviewer.md

### 19.2 `{{WORK_ITEM_TYPE}}`
- 의미: 작업 항목의 유형
- 타입: string
- 필수: 예
- 권장값: `feature`, `bugfix`, `chore`, `refactor`, `bootstrap`, `verification`, `recovery`
- 예시: `feature`
- 사용처: commit_session.sh, session_summary.json, current_task.json, claude-progress.txt

### 19.3 `{{WORK_ITEM_TITLE}}`
- 의미: 작업 항목의 제목
- 타입: string
- 필수: 예
- 예시: `사용자 로그인 API 구현`
- 사용처: session_summary.json, current_task.json, planner.md, coder.md, reviewer.md

### 19.4 `{{TASK_STATUS_SCHEMA_VERSION}}`
- 의미: current_task.json 스키마 버전 (CURRENT_TASK_SCHEMA_VERSION과 동일)
- 타입: string
- 필수: 예
- 예시: `v1.0`
- 사용처: current_task.json

---

## 20. Preflight/Post-Bootstrap 명령

`init.sh` 및 `bootstrap_env.sh`에서 사용하는 사전 점검 및 후속 명령 변수이다.

### 20.1 `{{CMD_PREFLIGHT_1}}`
- 의미: 사전 점검 명령 1 (bootstrap 중 preflight 단계)
- 타입: string
- 필수: 아니오
- 예시: `node --version`
- 사용처: init.sh, bootstrap_env.sh

### 20.2 `{{CMD_PREFLIGHT_2}}`
- 의미: 사전 점검 명령 2
- 타입: string
- 필수: 아니오
- 예시: `docker --version`
- 사용처: init.sh, bootstrap_env.sh

### 20.3 `{{CMD_PREFLIGHT_3}}`
- 의미: 사전 점검 명령 3
- 타입: string
- 필수: 아니오
- 사용처: init.sh, bootstrap_env.sh

### 20.4 `{{CMD_POST_BOOTSTRAP_1}}`
- 의미: 부트스트랩 이후 후속 명령 1
- 타입: string
- 필수: 아니오
- 예시: `pnpm seed:dev`
- 사용처: init.sh, bootstrap_env.sh

### 20.5 `{{CMD_POST_BOOTSTRAP_2}}`
- 의미: 부트스트랩 이후 후속 명령 2
- 타입: string
- 필수: 아니오
- 사용처: init.sh, bootstrap_env.sh

---

## 21. 추가 환경/메타 변수

`environment.json` 및 기타 JSON 템플릿에서 사용하는 환경, 경로, 정책 관련 추가 변수이다.

### 21.1 `{{ENV_FILE}}`
- 의미: 환경 변수 파일 경로 (.env 등)
- 타입: string
- 필수: 아니오
- 예시: `.env`
- 사용처: init.sh, bootstrap_env.sh, collect_status.sh, environment.json

### 21.2 `{{WORKING_DIRECTORY}}`
- 의미: 프로젝트 작업 디렉터리 경로
- 타입: string
- 필수: 권장
- 예시: `/home/user/project`
- 사용처: environment.json

### 21.3 `{{VERIFICATION_DIR_NAME}}`
- 의미: 검증 스크립트 디렉터리명
- 타입: string
- 필수: 예
- 예시: `verification`
- 사용처: environment.json

### 21.4 `{{CLAUDE_DIR_NAME}}`
- 의미: Claude 에이전트 설정 디렉터리명
- 타입: string
- 필수: 예
- 예시: `.claude`
- 사용처: environment.json

### 21.5 `{{ENVIRONMENT_SCHEMA_VERSION}}`
- 의미: environment.json 스키마 버전
- 타입: string
- 필수: 예
- 예시: `v1.0`
- 사용처: environment.json

### 21.6 `{{PROJECT_DESCRIPTION}}`
- 의미: 프로젝트 설명 문자열
- 타입: string
- 필수: 권장
- 예시: `장시간 코딩 에이전트 하네스 기반 프로젝트`
- 사용처: environment.json

### 21.7 `{{BOOTSTRAP_SUMMARY_FILE_PATH}}`
- 의미: 부트스트랩 요약 파일의 상대 경로
- 타입: string
- 필수: 예
- 예시: `state/bootstrap_summary.json`
- 사용처: environment.json, initializer.md

### 21.8 `{{SMOKE_REPORT_FILE_PATH}}`
- 의미: 스모크 리포트 파일의 상대 경로
- 타입: string
- 필수: 예
- 예시: `state/smoke_report.json`
- 사용처: environment.json, reviewer.md

### 21.9 `{{VERIFY_ALL_REPORT_FILE_PATH}}`
- 의미: 전체 검증 리포트 파일의 상대 경로
- 타입: string
- 필수: 예
- 예시: `state/verify_all_report.json`
- 사용처: environment.json, reviewer.md

### 21.10 `{{DEFAULT_OWNER_ROLE}}`
- 의미: 작업 항목의 기본 소유자 역할
- 타입: string
- 필수: 권장
- 예시: `coder`
- 사용처: environment.json, backlog.json

### 21.11 `{{DEFAULT_REVIEWER_ROLE}}`
- 의미: 작업 항목의 기본 리뷰어 역할
- 타입: string
- 필수: 권장
- 예시: `reviewer`
- 사용처: environment.json

---

## 22. 에이전트 모델/색상 변수

`.claude/agents/*.md` 프론트매터에서 사용하는 에이전트별 설정 변수이다.

### 22.1 `{{PLANNER_AGENT_MODEL}}`
- 의미: Planner 에이전트 사용 모델
- 타입: string
- 필수: 예
- 예시: `claude-sonnet-4-20250514`
- 사용처: planner.md

### 22.2 `{{PLANNER_AGENT_COLOR}}`
- 의미: Planner 에이전트 식별 색상
- 타입: string
- 필수: 아니오
- 예시: `blue`
- 사용처: planner.md

### 22.3 `{{CODER_AGENT_MODEL}}`
- 의미: Coder 에이전트 사용 모델
- 타입: string
- 필수: 예
- 예시: `claude-sonnet-4-20250514`
- 사용처: coder.md

### 22.4 `{{CODER_AGENT_COLOR}}`
- 의미: Coder 에이전트 식별 색상
- 타입: string
- 필수: 아니오
- 예시: `green`
- 사용처: coder.md

### 22.5 `{{REVIEWER_AGENT_MODEL}}`
- 의미: Reviewer 에이전트 사용 모델
- 타입: string
- 필수: 예
- 예시: `claude-sonnet-4-20250514`
- 사용처: reviewer.md

### 22.6 `{{REVIEWER_AGENT_COLOR}}`
- 의미: Reviewer 에이전트 식별 색상
- 타입: string
- 필수: 아니오
- 예시: `red`
- 사용처: reviewer.md

### 22.7 `{{INITIALIZER_AGENT_MODEL}}`
- 의미: Initializer 에이전트 사용 모델
- 타입: string
- 필수: 예
- 예시: `claude-sonnet-4-20250514`
- 사용처: initializer.md

### 22.8 `{{INITIALIZER_AGENT_COLOR}}`
- 의미: Initializer 에이전트 식별 색상
- 타입: string
- 필수: 아니오
- 예시: `yellow`
- 사용처: initializer.md

---

## 23. Backlog/Known Issues 정책 변수

`backlog.json` 및 `known_issues.json`의 정책 섹션에서 사용하는 변수이다.

### 23.1 `{{BACKLOG_SCHEMA_VERSION}}`
- 의미: backlog.json 스키마 버전
- 타입: string
- 필수: 예
- 예시: `v1.0`
- 사용처: backlog.json

### 23.2 `{{BACKLOG_SELECTION_STRATEGY}}`
- 의미: 백로그 작업 선택 전략
- 타입: string
- 필수: 권장
- 예시: `priority_first`
- 사용처: backlog.json, planner.md

### 23.3 `{{MAX_ACTIVE_TASKS}}`
- 의미: 동시 활성 작업 최대 수
- 타입: number
- 필수: 권장
- 예시: `1`
- 사용처: backlog.json, planner.md

### 23.4 `{{REQUIRE_DEPENDENCY_RESOLUTION}}`
- 의미: 작업 선택 시 의존성 해결 필수 여부
- 타입: boolean
- 필수: 권장
- 예시: `true`
- 사용처: backlog.json

### 23.5 `{{REQUIRE_REVIEW_FOR_HIGH_RISK}}`
- 의미: 고위험 작업에 리뷰 필수 여부
- 타입: boolean
- 필수: 권장
- 예시: `true`
- 사용처: backlog.json

### 23.6 `{{KNOWN_ISSUES_SCHEMA_VERSION}}`
- 의미: known_issues.json 스키마 버전
- 타입: string
- 필수: 예
- 예시: `v1.0`
- 사용처: known_issues.json

### 23.7 `{{SESSION_SUMMARY_SCHEMA_VERSION}}`
- 의미: session_summary.json 스키마 버전
- 타입: string
- 필수: 예
- 예시: `v1.0`
- 사용처: session_summary.json

### 23.8 `{{CURRENT_TASK_SCHEMA_VERSION}}`
- 의미: current_task.json 스키마 버전
- 타입: string
- 필수: 예
- 예시: `v1.0`
- 사용처: current_task.json

---

## 24. 인스턴스 번호 패턴

JSON 데이터 템플릿(`backlog.json`, `known_issues.json`, `session_summary.json`, `current_task.json`, `claude-progress.txt` 등)에서는 배열 항목 데이터를 위해 `_001`, `_002`, `_003` 등의 접미사가 붙은 변수를 사용한다.

### 패턴 규칙

1. **단일 수준 인덱스**: 기본 변수명에 `_001`, `_002`, `_003` 형태의 3자리 숫자 접미사를 붙인다.
   - 예: `{{ISSUE_ID_001}}`, `{{ISSUE_ID_002}}`
   - 예: `{{GROUP_ID_001}}`, `{{GROUP_ID_002}}`

2. **이중 수준 인덱스**: 그룹 내 항목은 `_GGG_III` 형태의 6자리(그룹 3자리 + 항목 3자리) 접미사를 사용한다.
   - 예: `{{TASK_ID_001_001}}` (그룹 001의 항목 001)
   - 예: `{{TASK_TITLE_002_001}}` (그룹 002의 항목 001)

3. **비그룹 항목**: 그룹에 속하지 않는 항목은 `_U001` 접미사를 사용한다.
   - 예: `{{TASK_ID_U001}}`, `{{TASK_TITLE_U001}}`

4. **하위 배열 인덱스**: 항목 내 하위 배열은 항목 인덱스 뒤에 `_01`, `_02` 형태의 2자리 접미사를 추가한다.
   - 예: `{{RELATED_FILE_001_01}}`, `{{RELATED_FILE_001_02}}`
   - 예: `{{DEPENDENCY_001_001_01}}` (그룹 001, 항목 001, 하위 01)

5. **확장 규칙**: 실제 데이터 항목 수에 맞춰 동일 패턴의 변수를 추가로 생성할 수 있다. 인스턴스 번호만 증가시키며, 기본 변수의 의미와 타입을 동일하게 유지한다.

이 패턴을 따르는 변수는 개별적으로 문서화하지 않으며, 기본 변수의 정의를 참조한다.

### 주요 인스턴스 변수 기본형 목록

| 사용처 | 기본 변수 패턴 | 설명 |
|--------|----------------|------|
| backlog.json | `GROUP_ID`, `GROUP_NAME`, `GROUP_TYPE`, `GROUP_PRIORITY`, `GROUP_DESCRIPTION` | 백로그 그룹 |
| backlog.json | `TASK_ID`, `TASK_TITLE`, `TASK_TYPE`, `TASK_CATEGORY`, `TASK_DESCRIPTION`, `TASK_PRIORITY`, `TASK_STATUS`, `TASK_PASSES` | 백로그 작업 항목 |
| known_issues.json | `ISSUE_ID`, `ISSUE_TITLE`, `ISSUE_CATEGORY`, `ISSUE_TYPE`, `ISSUE_DESCRIPTION`, `ISSUE_STATUS`, `ISSUE_SEVERITY`, `ISSUE_IMPACT`, `ISSUE_RISK_LEVEL` | 알려진 이슈 |
| session_summary.json | `PLANNED_SCOPE`, `ACTUAL_SCOPE`, `DESIGN_NOTE`, `PLANNED_STEP`, `COMPLETED_STEP` | 세션 요약 |
| claude-progress.txt | `PLANNED_SCOPE_LINE`, `OUT_OF_SCOPE_LINE`, `TARGET_FILE`, `ACTUAL_FILE` | 진행 기록 |

---

## 25. 최소 필수 변수 세트
초기 도입 시 반드시 먼저 확정해야 하는 최소 변수는 아래와 같다.

### 25.1 식별
- `{{PROJECT_NAME}}`
- `{{REPOSITORY_NAME}}`
- `{{HARNESS_TEMPLATE_VERSION}}`
- `{{DEFAULT_BRANCH}}`

### 25.2 경로
- `{{APP_DIR_NAME}}`
- `{{STATE_DIR_NAME}}`
- `{{LOG_DIR_NAME}}`
- `{{PID_DIR_NAME}}`
- `{{PROGRESS_FILE_PATH}}`
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{KNOWN_ISSUES_FILE_PATH}}`
- `{{SESSION_SUMMARY_FILE_PATH}}`

### 25.3 명령
- `{{CMD_BOOTSTRAP}}`
- `{{CMD_INSTALL}}`
- `{{CMD_DEV}}`
- `{{CMD_SMOKE}}`
- `{{CMD_VERIFY_ALL}}`

### 25.4 네트워크
- `{{HEALTHCHECK_URL}}`

### 25.5 정책
- `{{ALLOW_PARALLEL_TASKS}}`
- `{{REQUIRE_REVIEW_AGENT}}`
- `{{REQUIRE_FULL_VERIFY_FOR_CORE_CHANGE}}`
- `{{ALLOW_AUTO_COMMIT}}`
- `{{SESSION_MAX_SCOPE}}`

### 25.6 Bootstrap Enable 플래그
- `{{BOOTSTRAP_ENABLE_INSTALL}}`
- `{{BOOTSTRAP_ENABLE_INFRA}}`
- `{{BOOTSTRAP_ENABLE_DB_MIGRATE}}`
- `{{BOOTSTRAP_ENABLE_PREFLIGHT}}`
- `{{BOOTSTRAP_ENABLE_APP_START}}`
- `{{BOOTSTRAP_ENABLE_WORKER_START}}`
- `{{BOOTSTRAP_ENABLE_HEALTHCHECK}}`
- `{{BOOTSTRAP_ENABLE_POST_BOOTSTRAP}}`

### 25.7 리포트 파일명
- `{{SMOKE_REPORT_FILENAME}}`
- `{{VERIFY_ALL_REPORT_FILENAME}}`
- `{{STATUS_REPORT_FILENAME}}`

---

## 26. 권장 기본값 정책
프로젝트 성격이 아직 확정되지 않았을 때는 아래 기본값을 권장한다.

- `{{ALLOW_PARALLEL_TASKS}} = false`
- `{{REQUIRE_REVIEW_AGENT}} = true`
- `{{REQUIRE_FULL_VERIFY_FOR_CORE_CHANGE}} = true`
- `{{ALLOW_AUTO_COMMIT}} = false`
- `{{ROLLBACK_MODE}} = hard`
- `{{DEFAULT_BRANCH}} = main`
- `{{APP_HOST}} = localhost`
- `{{API_HOST}} = localhost`
- `{{DB_HOST}} = localhost`
- `{{CACHE_HOST}} = localhost`
- `{{BOOTSTRAP_ENABLE_INSTALL}} = true`
- `{{BOOTSTRAP_ENABLE_INFRA}} = false`
- `{{BOOTSTRAP_ENABLE_DB_MIGRATE}} = false`
- `{{BOOTSTRAP_ENABLE_PREFLIGHT}} = false`
- `{{BOOTSTRAP_ENABLE_APP_START}} = true`
- `{{BOOTSTRAP_ENABLE_WORKER_START}} = false`
- `{{BOOTSTRAP_ENABLE_HEALTHCHECK}} = true`
- `{{BOOTSTRAP_ENABLE_POST_BOOTSTRAP}} = false`
- `{{BOOTSTRAP_WAIT_SECONDS}} = 5`
- `{{ROLLBACK_ENABLED}} = true`
- `{{COMMIT_STAGE_ALL}} = false`
- `{{VERIFY_ALL_RUN_SMOKE_FIRST}} = true`

---

## 27. 변수 주입 체크리스트
실제 프로젝트에 적용하기 전에 아래를 점검한다.

### 27.1 식별 체크
- [ ] 프로젝트명 확정
- [ ] 저장소명 확정
- [ ] 기본 브랜치 확정

### 27.2 런타임 체크
- [ ] 런타임 타입 확정
- [ ] 주 스택 확정
- [ ] 패키지 매니저 확정

### 27.3 경로 체크
- [ ] app/state/log/pid 경로 확정
- [ ] 핵심 artifact 경로 확정

### 27.4 명령 체크
- [ ] install 명령 검증
- [ ] dev 명령 검증
- [ ] smoke 명령 검증
- [ ] verify_all 명령 검증
- [ ] optional test 명령 검증

### 27.5 네트워크 체크
- [ ] healthcheck URL 검증
- [ ] app/api/db/cache 포트 검증

### 27.6 정책 체크
- [ ] parallel task 정책 확정
- [ ] reviewer 필수 여부 확정
- [ ] full verify 정책 확정
- [ ] auto commit 정책 확정
- [ ] regression threshold 확정

### 27.7 Bootstrap Enable 체크
- [ ] BOOTSTRAP_ENABLE_INSTALL 확정
- [ ] BOOTSTRAP_ENABLE_INFRA 확정
- [ ] BOOTSTRAP_ENABLE_APP_START 확정
- [ ] BOOTSTRAP_ENABLE_HEALTHCHECK 확정
- [ ] BOOTSTRAP_WAIT_SECONDS 확정

### 27.8 Smoke/Verify 설정 체크
- [ ] SMOKE_ENABLE_* 플래그 확정
- [ ] SMOKE_TARGET_HOST/PORT 확정
- [ ] VERIFY_ENABLE_* 플래그 확정
- [ ] VERIFY_ALL_RUN_SMOKE_FIRST 확정
- [ ] SMOKE_REPORT_FILENAME 확정
- [ ] VERIFY_ALL_REPORT_FILENAME 확정

### 27.9 Rollback/Commit 체크
- [ ] ROLLBACK_ENABLED 확정
- [ ] ROLLBACK_MODE 확정
- [ ] COMMIT_STAGE_ALL 정책 확정

---

## 28. 예시 변수 세트
아래는 예시일 뿐이며 실제 프로젝트 값이 아니다.

```json
{
  "PROJECT_NAME": "sample-agent-project",
  "REPOSITORY_NAME": "sample-agent-project",
  "HARNESS_TEMPLATE_VERSION": "v1.0-template",
  "DEFAULT_BRANCH": "main",
  "RUNTIME_TYPE": "fullstack",
  "PRIMARY_STACK": "FastAPI + React + PostgreSQL",
  "PACKAGE_MANAGER": "pnpm",
  "APP_DIR_NAME": "app",
  "STATE_DIR_NAME": "state",
  "LOG_DIR_NAME": ".agent-logs",
  "PID_DIR_NAME": ".agent-pids",
  "CMD_BOOTSTRAP": "bash ./init.sh",
  "CMD_INSTALL": "pnpm install",
  "CMD_DEV": "pnpm dev",
  "CMD_SMOKE": "bash ./verification/smoke.sh",
  "CMD_VERIFY_ALL": "bash ./verification/verify_all.sh",
  "HEALTHCHECK_URL": "http://localhost:8000/health",
  "ALLOW_PARALLEL_TASKS": false,
  "REQUIRE_REVIEW_AGENT": true,
  "REQUIRE_FULL_VERIFY_FOR_CORE_CHANGE": true,
  "ALLOW_AUTO_COMMIT": false,
  "SESSION_MAX_SCOPE": "single bounded task",

  "BOOTSTRAP_ENABLE_INSTALL": true,
  "BOOTSTRAP_ENABLE_INFRA": false,
  "BOOTSTRAP_ENABLE_DB_MIGRATE": false,
  "BOOTSTRAP_ENABLE_PREFLIGHT": false,
  "BOOTSTRAP_ENABLE_APP_START": true,
  "BOOTSTRAP_ENABLE_WORKER_START": false,
  "BOOTSTRAP_ENABLE_HEALTHCHECK": true,
  "BOOTSTRAP_ENABLE_POST_BOOTSTRAP": false,
  "BOOTSTRAP_WAIT_SECONDS": 5,

  "SMOKE_ENABLE_PRECHECKS": false,
  "SMOKE_ENABLE_PROCESS_CHECK": true,
  "SMOKE_ENABLE_PORT_CHECK": true,
  "SMOKE_ENABLE_HEALTHCHECK": true,
  "SMOKE_ENABLE_API_PROBE": false,
  "SMOKE_ENABLE_UI_PROBE": false,
  "SMOKE_ENABLE_CUSTOM_CHECKS": false,
  "SMOKE_TARGET_HOST": "localhost",
  "SMOKE_TARGET_PORT": "3000",
  "PROCESS_MATCH_PATTERN": "node.*server.js",
  "SMOKE_REPORT_FILENAME": "smoke_report.json",
  "VERIFY_ALL_REPORT_FILENAME": "verify_all_report.json",
  "STATUS_REPORT_FILENAME": "status_report.json",

  "VERIFY_ENABLE_LINT": true,
  "VERIFY_ENABLE_TYPECHECK": true,
  "VERIFY_ENABLE_UNIT": true,
  "VERIFY_ENABLE_INTEGRATION": false,
  "VERIFY_ENABLE_E2E": false,
  "VERIFY_ENABLE_BUILD": true,
  "VERIFY_ALL_RUN_SMOKE_FIRST": true,

  "ROLLBACK_ENABLED": true,
  "ROLLBACK_MODE": "hard"
}
```

---

## 29. 최종 결론
이 변수 사전은 고정된 장시간 코딩 에이전트 하네스 구조에 프로젝트별 값을 주입하기 위한 표준 기준이다.

즉,
- 구조는 고정하고
- 의미는 표준화하고
- 값만 프로젝트별로 치환한다.

이 문서를 기준으로 템플릿 파일을 실제 프로젝트용 산출물로 변환할 수 있다.

---

## 30. 후속 적용 순서
1. 최소 필수 변수 세트 확정
2. 전체 변수 세트 확장
3. 템플릿 파일 일괄 치환
4. bootstrap / smoke baseline 검증
5. 첫 planner session 수행
6. 첫 coder session 수행
7. reviewer / quality gate 연결

