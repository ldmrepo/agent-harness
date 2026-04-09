# 장시간 코딩 에이전트 하네스 표준 문서

## 문서 정보
- 문서명: 장시간 코딩 에이전트 하네스 표준 문서
- 문서 버전: v1.0-standard
- 작성일: 2026-04-07
- 작성 기준: 고정 폴더/파일 구조 + 프로젝트 의존값 변수화
- 적용 범위: Claude Code / Anthropic 스타일 장시간 코딩 에이전트 하네스, 멀티세션 코딩 에이전트 운영, 설계·구현·리뷰·검증·복구 흐름

---

## 0. 문서 목적

본 문서는 장시간 코딩 에이전트 하네스를 운영하기 위한 표준 구조를 정의한다.
문서의 목적은 다음과 같다.
1. 고정된 폴더 및 파일 구조를 표준으로 고정한다.
2. 프로젝트 의존적인 값은 변수로 분리한다.
3. planner / initializer / coder / reviewer 역할을 구조화한다.
4. 세션 단위 설계·구현·리뷰·검증·복구 절차를 표준화한다.
5. 상태 인계를 파일 기반으로 강제한다.
6. verification / review / regression / recovery gate를 운영 정책으로 고정한다.
7. 실제 저장소에 바로 반영 가능한 템플릿 기준을 제공한다.

---

## 1. 표준 적용 원칙

### 1.1 구조 고정 원칙

다음 폴더 및 파일 구조는 표준 구조로 고정한다.
프로젝트별 차이는 구조 변경이 아니라 변수 주입으로 해결한다.

### 1.2 변수화 원칙

프로젝트에 종속되는 값은 반드시 변수로 처리한다.
예:
- 프로젝트명
- 저장소명
- 런타임 타입
- 포트
- healthcheck URL
- install/dev/build/test 명령
- review 정책
- commit prefix

### 1.3 세션 원칙

한 세션은 하나의 bounded work item을 기준으로 운영한다.
세션은 기본적으로 다음 순서를 따른다.
- 시작 상태 확인
- 미니 설계
- 구현 또는 리뷰 수행
- 검증
- 상태 기록
- 인계 또는 복구 결정

### 1.4 상태 외부화 원칙

상태는 대화 컨텍스트가 아니라 저장소 파일에 기록한다.
핵심 상태는 다음 파일에 남긴다.
- claude-progress.txt
- tasks/current_task.json
- feature_list.json
- state/session_summary.json
- state/known_issues.json
- state/environment.json

### 1.5 검증 우선 원칙

검증 없는 완료는 허용하지 않는다.
planned check는 증거가 아니며, executed evidence만 gate의 근거로 사용한다.

### 1.6 복구 우선 원칙

smoke 실패 또는 baseline 파손 상태에서는 정상 기능 개발보다 recovery가 우선한다.

---

## 2. 전체 표준 구조

### 2.1 최상위 구조

```text
{{REPOSITORY_NAME}}/
├─ AGENTS.md
├─ init.sh
├─ claude-progress.txt
├─ feature_list.json
├─ tasks/
│  ├─ current_task.json
│  ├─ backlog.json
│  └─ done/
├─ verification/
│  ├─ smoke.sh
│  ├─ verify_all.sh
│  ├─ e2e/
│  ├─ unit/
│  └─ integration/
├─ scripts/
│  ├─ bootstrap_env.sh
│  ├─ collect_status.sh
│  ├─ commit_session.sh
│  └─ rollback_last_good.sh
├─ state/
│  ├─ session_summary.json
│  ├─ known_issues.json
│  ├─ environment.json
│  └─ checkpoints/
├─ .claude/
│  ├─ agents/
│  └─ skills/
├─ docs/
│  ├─ architecture.md
│  ├─ runbook.md
│  └─ quality_gates.md
└─ {{APP_DIR_NAME}}/
```

### 2.2 계층 해석
1. Repository Policy Layer
2. Bootstrap Layer
3. Planning Layer
4. Implementation Layer
5. Review Layer
6. Verification Layer
7. State Handoff Layer
8. Recovery Layer
9. Skills Layer
10. Project Runtime Layer

---

## 3. 역할 구조

### 3.1 Planner

목적:
- 다음 bounded task 선택
- oversized task 분해
- scope / acceptance / verification 계획 수립

주요 입력:
- tasks/backlog.json
- tasks/current_task.json
- feature_list.json
- claude-progress.txt
- state/known_issues.json

주요 출력:
- tasks/current_task.json
- 계획 정합성 반영된 backlog/feature list

주의: planner는 "무엇을(what)" 정의하되 "어떻게(how)"는 coder에게 위임한다. 기술적 세부사항(파일명, 함수명, 구현 패턴)을 과도하게 지정하면 planner의 판단 오류가 구현으로 직접 전파된다.

### 3.2 Initializer

목적:
- 저장소 bootstrap / baseline 정규화
- 환경, 실행 경로, verification 진입점 구성
- 상태 파일 생성

주요 출력:
- init.sh
- state/environment.json
- verification/smoke.sh
- verification/verify_all.sh
- 상태 기반 파일들

### 3.3 Coder

목적:
- 선택된 단일 작업 구현
- verification 실행
- artifact 업데이트
- clean-state handoff 유지

### 3.4 Reviewer

목적:
- scope / correctness / verification / regression / clean-state 판정
- 승인, 반려, 보류, recovery 요구 결정

참고: reviewer는 아티팩트 검토뿐 아니라, 가능한 경우 실행 중인 애플리케이션을 직접 테스트하여 의도된 동작을 확인해야 한다. Playwright MCP 또는 동등한 도구가 사용 가능하면 UI/API를 직접 조작하여 검증한다. `{{REVIEWER_ENABLE_RUNTIME_VERIFICATION}} = true`일 때 활성화된다.

---

## 4. 세션 표준 절차

### 4.1 Session Start
1. repository root 확인
2. claude-progress.txt 읽기
3. feature_list.json 읽기
4. tasks/current_task.json 읽기
5. state/known_issues.json 읽기
6. 최근 git log 확인
7. {{CMD_BOOTSTRAP}} 실행
8. {{CMD_SMOKE}} 실행
9. smoke 결과에 따라 normal flow 또는 recovery flow 결정

### 4.2 Mini Design
- 이번 세션 목표 1개 선정
- in-scope 정의
- out-of-scope 정의
- expected files 정의
- acceptance criteria 정의
- verification plan 정의

### 4.3 Implementation / Review Work

선택된 역할에 따라 수행:
- planner: task selection / split
- initializer: bootstrap normalization
- coder: bounded task implementation
- reviewer: evidence-based review

### 4.4 Verification
- smoke
- task-level verification
- verify_all 필요 시 실행
- report / result 기록

### 4.5 Artifact Update

최소 업데이트 대상:
- tasks/current_task.json
- claude-progress.txt
- state/session_summary.json

조건부 업데이트 대상:
- feature_list.json
- tasks/backlog.json
- state/known_issues.json

### 4.6 Handoff / Commit / Recovery Decision
- clean state 여부 판단
- 다음 세션 추천 단계 기록
- auto commit 정책 충족 시 commit 수행
- recovery 필요 시 recovery flow로 전환

---

## 5. 핵심 파일 표준

### 5.1 AGENTS.md

역할:
- 저장소 운영 정책의 단일 기준
- session start / task selection / verification / clean state / do-not rules 정의

필수 포함 항목:
- Purpose
- Required Repository Files
- Global Principles
- Project Variables
- Agent Roles
- Session Lifecycle
- Task Selection Rules
- Verification Policy
- Progress Logging Policy
- Git Policy
- Clean-State Definition
- Failure and Recovery Policy
- End-of-Session Checklist

### 5.2 init.sh

역할:
- 장시간 세션 기준 bootstrap 진입점
- install / infra / migrate / app / worker / healthcheck / summary 수행

프로젝트 종속값:
- {{CMD_INSTALL}}
- {{CMD_INFRA_UP}}
- {{CMD_DB_MIGRATE}}
- {{CMD_DEV}}
- {{CMD_WORKER}}
- {{HEALTHCHECK_URL}}
- 각종 enable flag

### 5.3 claude-progress.txt

역할:
- append-only 세션 인계 로그
- 설계/구현/검증/블로커/다음 단계 기록

### 5.4 feature_list.json

역할:
- feature/task 기준 목록
- passes / verification / dependencies / completion criteria 관리

### 5.5 tasks/current_task.json

역할:
- 현재 세션의 단일 작업 상태
- 범위, 설계, 구현, 검증, 리뷰, handoff를 구조화

### 5.6 tasks/backlog.json

역할:
- 장기 작업 후보 목록
- 그룹별 우선순위와 dependency 구조 관리

### 5.7 state/session_summary.json

역할:
- 세션 종료 시점의 구조화된 결과
- verification / review / regression / clean-state / handoff를 요약

### 5.8 state/known_issues.json

역할:
- 알려진 문제, blocker, workaround, close conditions 관리

### 5.9 state/environment.json

역할:
- 프로젝트 환경 기준 파일
- 실행/검증/경로/정책/런타임 상태를 구조화

---

## 6. Verification 구조 표준

### 6.1 verification/smoke.sh

목적:
- 최소 실행 가능 상태 확인
- repository marker, required files, process/port/health, custom smoke 검사

출력:
- smoke report JSON
- exit code 0/1

### 6.2 verification/verify_all.sh

목적:
- lint / typecheck / unit / integration / e2e / build / schema / security / perf / custom checks 통합 실행

출력:
- verify_all report JSON
- exit code 0/1

### 6.3 Verification 수준
- smoke
- unit
- integration
- e2e
- verify_all
- custom gate

### 6.4 검증 원칙
1. executed evidence만 인정
2. smoke는 baseline gate이며 task correctness 전체를 대체하지 않음
3. core/shared change 시 full verification 또는 동등 수준 필요
4. skipped checks는 명시적으로 기록

---

## 7. Recovery / 운영 스크립트 표준

### 7.1 scripts/bootstrap_env.sh

역할:
- environment bootstrap 전용 보조 스크립트
- install / infra / migrate / start / healthcheck / state 기록 수행

### 7.2 scripts/collect_status.sh

역할:
- git 상태, runtime 상태, artifact 존재 여부, health/port 상태 수집
- reviewer / recovery / session start 보조

### 7.3 scripts/commit_session.sh

역할:
- 정책 기반 커밋 보조
- task type별 prefix 적용
- clean-state flag 기반 커밋 허용 판단

### 7.4 scripts/rollback_last_good.sh

역할:
- known-good commit으로 복구
- soft/mixed/hard 모드 지원
- 필요 시 smoke 재검증 및 status 수집 수행

---

## 8. .claude/agents 표준

### 8.1 planner.md

핵심 책임:
- bounded next task 선택
- oversized task split
- current task handoff 생성

### 8.2 initializer.md

핵심 책임:
- bootstrap / verification / state artifact baseline 생성

### 8.3 coder.md

핵심 책임:
- selected bounded task 구현
- verification 수행
- state artifact update

### 8.4 reviewer.md

핵심 책임:
- scope / correctness / verification / regression / clean-state 판정

---

## 9. .claude/skills 표준

### 9.1 repo-bootstrap/SKILL.md

용도:
- 저장소 bootstrap 정규화

### 9.2 task-breakdown/SKILL.md

용도:
- 큰 작업을 session-sized task로 분해

### 9.3 feature-implementation/SKILL.md

용도:
- bounded feature task 구현

### 9.4 bug-fix-workflow/SKILL.md

용도:
- 재현 → 격리 → 수정 → 검증 → 기록 기반 bugfix

### 9.5 code-review-checklist/SKILL.md

용도:
- evidence-based review checklist 적용

### 9.6 regression-check/SKILL.md

용도:
- changed surface 기준 regression risk 평가

### 9.7 test-gate/SKILL.md

용도:
- verification gate depth와 executed evidence 기반 pass/fail/pending 판정

---

## 10. 품질 게이트 표준

### 10.1 Gate 순서
1. Repository Readiness Gate
2. Task Selection Gate
3. Implementation Scope Gate
4. Verification Gate
5. Regression Gate
6. Review Gate
7. Pass / Completion Gate
8. Recovery Gate

### 10.2 Readiness Gate

통과 조건:
- 핵심 artifact 존재
- bootstrap 경로 존재
- smoke 경로 존재
- baseline runtime 확인 가능

### 10.3 Task Selection Gate

통과 조건:
- bounded scope
- dependency satisfied
- verification path 정의
- blocked recovery task보다 우선순위 적절

### 10.4 Implementation Scope Gate

통과 조건:
- selected task와 실제 작업 일치
- out-of-scope 위반 없음
- 예상 파일 범위 또는 정당화된 인접 변경

### 10.5 Verification Gate

통과 조건:
- required checks 실행됨
- 결과 기록됨
- task impact에 맞는 깊이의 검증 수행됨

### 10.6 Regression Gate

통과 조건:
- changed surface 기준 인접 영향 평가 완료
- residual risk가 허용 수준 이내
- blocking regression 없음

### 10.7 Review Gate

통과 조건:
- review required 시 명시적 reviewer decision 존재
- scope / correctness / verification / artifact consistency 점검 완료

### 10.8 Pass Gate

통과 조건:
- 모든 선행 gate 충족
- artifact state 일치
- clean state 달성

### 10.9 Recovery Gate

활성화 조건:
- smoke failure
- severe regression
- broken baseline
- blocked runtime
- rollback이 더 안전한 경우

---

## 11. 문서 계층 표준

### 11.1 docs/architecture.md

목적:
- 상위 구조, 계층, 역할, state/verification/recovery architecture 설명

### 11.2 docs/runbook.md

목적:
- session start → planning → init → coding → review → recovery → commit까지의 실제 운영 절차 설명

### 11.3 docs/quality_gates.md

목적:
- readiness / scope / verification / regression / review / pass / recovery 기준 정의

---

## 12. 변수 표준

### 12.1 식별 변수
- {{PROJECT_NAME}}
- {{REPOSITORY_NAME}}
- {{HARNESS_TEMPLATE_VERSION}}
- {{CREATED_AT}}
- {{UPDATED_AT}}

### 12.2 런타임 변수
- {{RUNTIME_TYPE}}
- {{PRIMARY_STACK}}
- {{LANGUAGE_MAIN}}
- {{LANGUAGE_SECONDARY}}
- {{PACKAGE_MANAGER}}
- {{DEFAULT_BRANCH}}

### 12.3 경로 변수
- {{APP_DIR_NAME}}
- {{DOCS_DIR_NAME}}
- {{TASKS_DIR_NAME}}
- {{STATE_DIR_NAME}}
- {{LOG_DIR_NAME}}
- {{PID_DIR_NAME}}
- {{AGENTS_FILE_PATH}}
- {{ENVIRONMENT_FILE_PATH}}
- {{PROGRESS_FILE_PATH}}
- {{FEATURE_LIST_FILE_PATH}}
- {{CURRENT_TASK_FILE_PATH}}
- {{BACKLOG_FILE_PATH}}
- {{KNOWN_ISSUES_FILE_PATH}}
- {{SESSION_SUMMARY_FILE_PATH}}

### 12.4 명령 변수
- {{CMD_BOOTSTRAP}}
- {{CMD_INSTALL}}
- {{CMD_INFRA_UP}}
- {{CMD_DB_MIGRATE}}
- {{CMD_DEV}}
- {{CMD_WORKER}}
- {{CMD_SMOKE}}
- {{CMD_VERIFY_ALL}}
- {{CMD_LINT}}
- {{CMD_TYPECHECK}}
- {{CMD_TEST_UNIT}}
- {{CMD_TEST_INTEGRATION}}
- {{CMD_TEST_E2E}}
- {{CMD_COLLECT_STATUS}}

### 12.5 정책 변수
- {{ALLOW_PARALLEL_TASKS}}
- {{REQUIRE_REVIEW_AGENT}}
- {{REQUIRE_FULL_VERIFY_FOR_CORE_CHANGE}}
- {{ALLOW_AUTO_COMMIT}}
- {{SESSION_MAX_SCOPE}}
- {{REGRESSION_RISK_THRESHOLD_FOR_REJECTION}}
- {{REGRESSION_RISK_THRESHOLD_FOR_PENDING}}

### 12.6 복구 변수
- {{ROLLBACK_TARGET_COMMIT}}
- {{ROLLBACK_REASON}}
- {{ROLLBACK_MODE}}

### 12.7 네트워크 변수
- {{APP_HOST}}
- {{APP_PORT}}
- {{API_HOST}}
- {{API_PORT}}
- {{DB_HOST}}
- {{DB_PORT}}
- {{CACHE_HOST}}
- {{CACHE_PORT}}
- {{HEALTHCHECK_URL}}

---

## 13. 최종 운영 기준

### 13.1 시작 가능 조건
- artifact 존재
- bootstrap 가능
- smoke 가능
- known issues 확인 완료

### 13.2 구현 가능 조건
- selected task가 bounded
- verification plan 존재
- smoke baseline 통과

### 13.3 승인 가능 조건
- verification evidence 존재
- regression risk 허용 수준
- review required 시 reviewer decision 완료
- artifact 상태 일치

### 13.4 복구 전환 조건
- smoke failure
- broken clean state
- severe regression
- blocked baseline

---

## 14. 최종 결론

본 표준 문서는 다음을 고정한다.
1. 폴더 및 파일 구조
2. planner / initializer / coder / reviewer 역할 구조
3. state artifact 체계
4. verification / regression / review / recovery gate 체계
5. bootstrap / status / commit / rollback 스크립트 구조
6. architecture / runbook / quality gates 문서 구조
7. 프로젝트 의존값의 변수화 원칙

즉, 이 표준은 단순한 프롬프트 모음이 아니라 장시간 코딩 에이전트 운영을 위한 저장소 표준 운영 체계이다.

이 문서를 기준으로 각 템플릿 파일은 실제 저장소에 생성·주입·치환되어 사용할 수 있다.

---

## 15. 후속 적용 순서
1. 변수 사전 확정
2. 템플릿 파일 생성
3. 프로젝트 값 주입
4. bootstrap / smoke baseline 검증
5. 첫 planner session 수행
6. 첫 bounded coding session 수행
7. reviewer / quality gate 연결
8. recovery 및 rollback 정책 점검

---

## 16. 부록: 최소 도입 세트

초기 MVP 도입 시 최소 세트는 다음과 같다.
- AGENTS.md
- init.sh
- claude-progress.txt
- feature_list.json
- tasks/current_task.json
- verification/smoke.sh
- state/environment.json
- .claude/agents/planner.md
- .claude/agents/coder.md
- .claude/agents/reviewer.md
- docs/architecture.md
- docs/runbook.md
- docs/quality_gates.md

확장 단계에서 다음을 추가한다.
- tasks/backlog.json
- state/known_issues.json
- state/session_summary.json
- verification/verify_all.sh
- recovery scripts
- skill 세트 전체
