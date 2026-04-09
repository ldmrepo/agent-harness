# 장시간 코딩 에이전트 하네스 사용 가이드

## 목차

1. [하네스란 무엇인가](#1-하네스란-무엇인가)
2. [신규 프로젝트에 적용하기](#2-신규-프로젝트에-적용하기)
3. [세션 운영 방법](#3-세션-운영-방법)
4. [에이전트 역할별 가이드](#4-에이전트-역할별-가이드)
5. [검증 체계](#5-검증-체계)
6. [상태 파일 관리](#6-상태-파일-관리)
7. [복구 절차](#7-복구-절차)
8. [작업 관리](#8-작업-관리)
9. [실전 시나리오](#9-실전-시나리오)
10. [FAQ](#10-faq)

---

## 1. 하네스란 무엇인가

### 1.1 개요

이 하네스는 AI 코딩 에이전트(Claude Code 등)가 여러 세션에 걸쳐 안정적으로 작업할 수 있도록 구조, 규칙, 검증, 복구 체계를 제공하는 **템플릿 기반 운영 프레임워크**입니다.

Anthropic의 [Harness Design for Long-Running Application Development](https://www.anthropic.com/engineering/harness-design-long-running-apps) 원칙에 기반합니다.

### 1.2 핵심 원칙

1. **한 세션, 한 작업** — 세션당 하나의 bounded work item만 처리
2. **검증 없는 완료 불가** — 실행된 증거만 인정, "looks right"는 불충분
3. **상태는 파일에 기록** — 대화 컨텍스트가 아닌 저장소 파일에 외부화
4. **복구가 우선** — smoke 실패 시 기능 개발보다 복구가 우선
5. **생성과 평가의 분리** — 구현하는 에이전트와 평가하는 에이전트를 분리

### 1.3 에이전트 역할

| 역할 | 담당 | 주요 산출물 |
|------|------|-----------|
| **Planner** | 다음 작업 1개 선택, 범위 정의 | `tasks/current_task.json` |
| **Reviewer** | 계약 사전 검토 + 구현 사후 평가 | 승인/반려 판정 |
| **Coder** | 승인된 범위 내 구현 + 검증 실행 | 코드, 테스트, 검증 결과 |
| **Initializer** | 저장소 부트스트랩 정규화 | `init.sh`, 상태 파일 |

---

## 2. 신규 프로젝트에 적용하기

### 2.1 템플릿 복사

```bash
cp -r agent-harness/ my-new-project/
cd my-new-project/
rm -rf .git
git init
```

### 2.2 변수 치환

하네스의 모든 파일에는 `{{VARIABLE_NAME}}` 형식의 플레이스홀더가 있습니다. 이를 프로젝트 실제 값으로 치환해야 합니다.

```bash
# 방법 A: 대화형 — 28개 필수 변수를 하나씩 입력
bash configure.sh --interactive

# 방법 B: JSON 파일 준비 후 일괄 적용
bash configure.sh --generate-example                        # 예시 JSON 생성
vi project_variables.example.json                           # 값 수정
bash configure.sh --config project_variables.example.json --dry-run  # 미리보기
bash configure.sh --config project_variables.example.json            # 적용
```

변수는 다음 카테고리로 구성됩니다:

| 카테고리 | 예시 | 설명 |
|---------|------|------|
| 식별 | PROJECT_NAME, REPOSITORY_NAME | 프로젝트 기본 정보 |
| 런타임 | RUNTIME_TYPE, PRIMARY_STACK | 기술 스택 정보 |
| 경로 | APP_DIR_NAME, STATE_DIR_NAME | 디렉토리 구조 |
| 명령 | CMD_INSTALL, CMD_DEV, CMD_SMOKE | 실행 명령어 |
| 네트워크 | APP_PORT, HEALTHCHECK_URL | 포트 및 엔드포인트 |
| 정책 | ALLOW_PARALLEL_TASKS, REQUIRE_REVIEW_AGENT | 운영 정책 플래그 |
| Bootstrap | BOOTSTRAP_ENABLE_INSTALL, BOOTSTRAP_ENABLE_APP_START | 부트스트랩 단계 제어 |

전체 170+개 변수의 상세 정의는 `long_running_agent_harness_variable_dictionary.md`를 참조하세요.

### 2.3 프로젝트 코드 추가

변수 치환 후 실제 프로젝트 코드를 추가합니다:

```bash
mkdir -p app tests/unit tests/integration
# 앱 코드, 테스트, 설정 파일 작성
```

### 2.4 feature_list.json에 작업 등록

`feature_list.json`의 템플릿 항목을 실제 작업으로 교체합니다:

```json
{
  "id": "F-001",
  "title": "첫 번째 기능",
  "priority": 1,
  "status": "not_started",
  "passes": false,
  "depends_on": [],
  "completion_criteria": ["검증 가능한 기준 1", "검증 가능한 기준 2"],
  "verification_commands": ["테스트 명령어"]
}
```

### 2.5 부트스트랩 및 스모크 검증

```bash
bash ./init.sh                    # 환경 부트스트랩
bash ./verification/smoke.sh      # 최소 실행 가능 상태 확인
git add -A && git commit -m "feat: initial harness setup"
```

### 2.6 적용 체크리스트

```
[ ] 변수 치환 완료 (grep '{{' 로 남은 플레이스홀더 확인)
[ ] init.sh 실행 성공
[ ] smoke.sh 통과
[ ] feature_list.json에 작업 최소 1개 등록
[ ] claude-progress.txt 초기 엔트리 작성
[ ] state/environment.json 실제 값으로 채움
[ ] .gitignore가 .agent-logs/, .agent-pids/ 제외 확인
```

---

## 3. 세션 운영 방법

### 3.1 세션 라이프사이클

모든 세션은 아래 8단계를 따릅니다:

```
1. Start      → 상태 파일 읽기, 부트스트랩, 스모크 체크
2. Plan       → 작업 1개 선택 (planner)
3. Contract   → reviewer가 범위/검증 계획 사전 합의
4. Implement  → 승인된 범위 내에서 구현 (coder)
5. Verify     → 스모크 + 기능 레벨 + 런타임 검증
6. Review     → reviewer가 증거 기반 평가
7. Record     → 상태 파일 업데이트, progress 기록
8. Handoff    → 다음 세션이 이어받을 수 있는 상태로 종료
```

### 3.2 세션 시작 절차 (모든 세션 공통)

세션을 시작할 때 반드시 아래 순서를 따르세요:

1. 저장소 루트 확인
2. `claude-progress.txt` 읽기 — 이전 세션 이력 확인
3. `feature_list.json` 읽기 — 작업 상태 확인
4. `tasks/current_task.json` 읽기 — 진행 중 작업 확인
5. `state/known_issues.json` 읽기 — 알려진 이슈 확인
6. `git log --oneline -20` — 최근 변경 확인
7. `bash ./init.sh` — 부트스트랩
8. `bash ./verification/smoke.sh` — 스모크 검증
   - smoke 실패 시 기능 작업 금지, 복구 우선

### 3.3 세션 종료 절차

1. 검증 실행 (smoke 최소, 필요 시 verify_all)
2. `feature_list.json` 작업 상태 업데이트
3. `claude-progress.txt`에 세션 엔트리 추가 (append-only)
4. `state/session_summary.json` 업데이트
5. 커밋 (정책 허용 시 `bash ./scripts/commit_session.sh`)
6. 저장소가 다음 세션에서 재개 가능한 상태인지 확인

---

## 4. 에이전트 역할별 가이드

### 4.1 Planner (기획)

**정의 파일:** `.claude/agents/planner.md`

**역할:**
- `feature_list.json`과 `tasks/backlog.json`에서 다음 작업 1개 선택
- 범위(in-scope/out-of-scope), 수용 기준, 검증 계획 정의
- `tasks/current_task.json` 생성

**핵심 규칙:**
- "무엇을(what)" 정의하되 "어떻게(how)"는 coder에게 위임
- 파일 목록은 참고용, coder가 실제 구현 경로 결정
- 한 세션에 하나의 작업만 선택
- smoke 실패 시 기능 작업 대신 복구 작업 선택

### 4.2 Reviewer — Contract Review (계약 검토)

**정의 파일:** `.claude/agents/reviewer.md`

**역할 (구현 전):**
- planner가 만든 `current_task.json`의 범위, 수용 기준, 검증 계획을 검토
- 모호한 기준, 검증 불가능한 조건, 과도한 범위를 거부

**결과:**
- `contract_status`: `approved` / `rejected` / `revision_needed`
- 거부 시 planner에게 반환하여 수정

### 4.3 Coder (구현)

**정의 파일:** `.claude/agents/coder.md`

**역할:**
- `current_task.json`에서 승인된 작업만 구현
- 범위 내에서만 파일 수정
- 검증 실행 후 결과 기록

**핵심 규칙:**
- `contract_status`가 `approved`가 아니면 구현 시작 금지
- 관련 없는 리팩토링, 코드 정리 금지
- smoke 실패 시 즉시 중단, 복구 우선
- 검증 없이 완료 선언 금지

### 4.4 Reviewer — Implementation Review (구현 검토)

**역할 (구현 후):**
- 범위 준수, 정확성, 검증 증거, 회귀 위험 평가
- 가능하면 실행 중인 앱을 직접 테스트 (Runtime Verification)
- 승인(`approved`), 반려(`rejected`), 보류(`pending`) 결정

**QA 튜닝:**
- `[QA-UNCERTAIN]`: 판단이 애매한 부분 표시
- `[QA-RATIONALIZATION-RISK]`: 증거 부족한데 승인하려는 유혹 표시
- 놓친 이슈는 `state/qa_tuning_log.json`에 기록

### 4.5 Initializer (초기화)

**정의 파일:** `.claude/agents/initializer.md`

**역할:**
- 저장소 부트스트랩 절차 정규화
- `init.sh`, `state/environment.json`, 검증 스크립트 정비
- 최초 세션 또는 환경 변경 시 사용

---

## 5. 검증 체계

### 5.1 검증 수준

| 수준 | 스크립트/명령 | 용도 |
|------|-------------|------|
| **Smoke** | `verification/smoke.sh` | 최소 실행 가능 상태 확인 (필수 파일, 프로세스, 포트, 헬스체크) |
| **Unit** | 프로젝트별 테스트 명령 | 단위 테스트 |
| **Integration** | 프로젝트별 테스트 명령 | 통합 테스트 (DB, API 포함) |
| **Lint / Typecheck** | 프로젝트별 린트/타입 명령 | 코드 품질 |
| **Full** | `verification/verify_all.sh` | 위 모든 검증 통합 실행 |

### 5.2 8단계 품질 게이트

```
1. Repository Readiness  → 핵심 파일 존재, 부트스트랩 가능
2. Task Selection        → bounded scope, 의존성 충족, 계약 승인
3. Implementation Scope  → 실제 변경이 선택 범위와 일치
4. Verification          → 필요한 검증 실행, 결과 기록
5. Regression            → 인접 기능 영향 평가
6. Review                → reviewer의 명시적 판정
7. Pass / Completion     → 모든 선행 게이트 충족
8. Recovery              → smoke 실패, 심각한 회귀 시 활성화
```

### 5.3 검증 원칙

- **실행된 증거만 인정** — "예정된 체크"는 증거가 아님
- **smoke는 baseline** — 기능 정확성 전체를 대체하지 않음
- **core 변경 시 full verify** — 공유 코드 변경 시 `verify_all.sh` 실행
- **건너뛴 체크는 명시적으로 기록**

---

## 6. 상태 파일 관리

### 6.1 핵심 상태 파일

| 파일 | 역할 | 갱신 시점 |
|------|------|----------|
| `claude-progress.txt` | 세션별 진행 이력 (append-only) | 매 세션 종료 시 |
| `feature_list.json` | 작업 목록 + 완료 상태 | 작업 상태 변경 시 |
| `tasks/current_task.json` | 현재 세션의 단일 작업 | planner가 선택 시 |
| `tasks/backlog.json` | 장기 작업 후보 | 작업 추가/정리 시 |
| `state/session_summary.json` | 세션 결과 요약 | 매 세션 종료 시 |
| `state/known_issues.json` | 알려진 이슈 레지스트리 | 이슈 발견/해결 시 |
| `state/environment.json` | 런타임 환경 정보 | 환경 변경 시 |
| `state/qa_tuning_log.json` | reviewer QA 효과 추적 | 놓친 이슈 발견 시 |

### 6.2 claude-progress.txt 작성 예시

```
================================================================
Session: 2026-04-10T10:00:00+09:00
Session Type: coding
Project: my-project
Repository: my-project
Branch: main
================================================================

Selected Work Item: F-001
Goal: 작업 목표 설명

Scope:
- In Scope: 범위 내 항목
- Out of Scope: 범위 외 항목

Files Changed:
- path/to/file.py (신규 또는 수정)

Verification Executed:
- pytest tests/unit -q → passed
- bash ./verification/smoke.sh → passed

Result: passed
Reviewer Status: approved
Task Status: passed

Known Issues: none
Recommended Next Step: 다음 작업 설명
================================================================
```

---

## 7. 복구 절차

### 7.1 smoke 실패 시

1. `bash ./scripts/collect_status.sh` — 현재 상태 수집
2. 상태 리포트 확인 — 원인 진단
3. 복구 시도
   - 직접 수정 가능하면 수정
   - 불가능하면 롤백: `bash ./scripts/rollback_last_good.sh HEAD~1 "사유"`
4. `bash ./verification/smoke.sh` — 복구 후 재검증
5. `state/known_issues.json`에 이슈 기록

### 7.2 롤백 모드

| 모드 | 동작 |
|------|------|
| soft | 커밋만 되돌림, 변경사항은 staged 상태 유지 |
| mixed | 커밋 되돌림, 변경사항은 unstaged 상태 |
| hard (기본값) | 커밋 + 변경사항 모두 되돌림 |

### 7.3 복구 판단 기준

- smoke 실패 → 기능 작업 중단, 복구 우선
- 심각한 회귀 → 롤백 후 원인 분석
- 기반 파손 → `collect_status.sh`로 상태 파악 후 결정
- 복구 후 반드시 `claude-progress.txt`에 기록

---

## 8. 작업 관리

### 8.1 작업 선택 규칙

1. `not_started` 상태의 작업 중 우선순위가 가장 높은 것 선택
2. 의존성이 충족된 작업만 선택 가능
3. smoke가 통과해야 기능 작업 선택 가능
4. 작업이 너무 크면 분할 후 선택

### 8.2 작업 추가 방법

`feature_list.json`에 새 항목 추가:

```json
{
  "id": "F-001",
  "category": "core",
  "type": "feature",
  "title": "작업 제목",
  "description": "작업 설명",
  "priority": 1,
  "status": "not_started",
  "passes": false,
  "verification_type": "unit",
  "risk": "low",
  "depends_on": [],
  "completion_criteria": ["검증 가능한 기준 1", "검증 가능한 기준 2"],
  "verification_commands": ["테스트 명령어"]
}
```

### 8.3 작업 상태 값

| 상태 | 의미 |
|------|------|
| `not_started` | 아직 시작하지 않음 |
| `in_progress` | 구현 중 |
| `blocked` | 블로커에 의해 중단 |
| `verified` | 검증 완료, 리뷰 대기 |
| `passed` | 리뷰 승인, 완료 |
| `rejected` | 리뷰 반려, 재작업 필요 |

---

## 9. 실전 시나리오

### 9.1 시나리오: 일반적인 기능 구현

```
세션 1 — Planner
  ├─ feature_list.json 읽기
  ├─ 다음 작업 1개 선택
  ├─ current_task.json 생성 (범위, 기준, 검증 계획)
  └─ contract_status: pending_review

세션 2 — Reviewer (Contract Review)
  ├─ current_task.json의 범위/기준/검증계획 검토
  ├─ 수용 기준이 검증 가능한지 확인
  └─ contract_status: approved (또는 revision_needed)

세션 3 — Coder
  ├─ contract_status = approved 확인
  ├─ 승인된 범위 내에서 구현
  ├─ 테스트 작성
  ├─ 검증 실행 → 통과
  ├─ feature_list.json 상태 업데이트
  └─ claude-progress.txt 엔트리 추가

세션 4 — Reviewer (Implementation Review)
  ├─ 범위 준수 확인
  ├─ 검증 증거 확인
  ├─ 런타임 검증 (가능한 경우)
  ├─ 회귀 위험 평가
  └─ 승인: passes = true
```

### 9.2 시나리오: smoke 실패 복구

```
세션 시작
  ├─ bash ./verification/smoke.sh → FAILED
  ├─ 기능 작업 시작 금지!
  ├─ bash ./scripts/collect_status.sh
  ├─ 원인 진단 및 해결
  ├─ bash ./init.sh (재시작)
  ├─ bash ./verification/smoke.sh → PASSED
  ├─ known_issues.json에 기록
  └─ claude-progress.txt에 recovery 세션 기록
```

### 9.3 시나리오: reviewer 반려 후 재작업

```
Reviewer: 수용 기준 미충족 사유 기록
  ├─ 반려 이유 기록
  └─ task status: rejected

Coder (재작업 세션):
  ├─ 반려 사유 확인
  ├─ 수정 및 테스트 추가
  ├─ 검증 실행 → 통과
  └─ 재검토 요청

Reviewer (재검토):
  ├─ 수정 확인, 테스트 증거 확인
  └─ 승인
```

---

## 10. FAQ

### Q: 세션이 중간에 끊기면 어떻게 되나요?

`claude-progress.txt`와 `tasks/current_task.json`에 마지막 상태가 기록되어 있으므로, 다음 세션에서 파일을 읽고 이어서 작업할 수 있습니다. 이것이 하네스의 핵심 가치입니다.

### Q: planner 없이 바로 코딩해도 되나요?

가능하지만 권장하지 않습니다. planner 단계를 거치면 범위가 명확해지고, reviewer의 contract review로 사전 검증됩니다. 범위 없이 시작하면 scope drift 위험이 높아집니다.

### Q: 모든 작업에 reviewer가 필요한가요?

`REQUIRE_REVIEW_AGENT` 정책이 `true`이면 필요합니다. 급한 hotfix 등 예외 시 coder가 자기 검토를 수행하되, 반드시 검토 내용을 기록해야 합니다.

### Q: 테스트가 없는 작업도 통과할 수 있나요?

검증 방법은 작업에 따라 다릅니다. 테스트 코드가 아니더라도 "실행된 증거"(smoke 통과, curl 응답 확인, 로그 확인 등)가 있어야 합니다. 증거 없는 완료는 불가합니다.

### Q: 하네스 구조를 프로젝트에 맞게 바꿔도 되나요?

폴더/파일 구조는 고정이 원칙이지만, 검증 단계(verify_all.sh의 enable 플래그)나 정책 변수는 프로젝트에 맞게 조정할 수 있습니다. 구조적 변경이 필요하면 `docs/harness_assumptions.md`의 감사 절차를 통해 결정하세요.

### Q: 여러 에이전트를 동시에 실행할 수 있나요?

`ALLOW_PARALLEL_TASKS` 정책이 `false`이면 불가합니다. 한 번에 하나의 세션, 하나의 작업이 원칙입니다.

### Q: 하네스의 규칙이 너무 엄격하면 어떻게 하나요?

`docs/harness_assumptions.md`에서 각 규칙이 어떤 모델 한계를 가정하는지 확인하세요. 모델이 개선되어 해당 가정이 더 이상 유효하지 않다면, Harness Audit Session을 통해 규칙을 완화할 수 있습니다.

---

## 부록: 주요 파일 경로 요약

| 파일 | 용도 |
|------|------|
| `AGENTS.md` | 하네스 운영 정책 (모든 규칙의 기준) |
| `init.sh` | 부트스트랩 진입점 |
| `configure.sh` | 템플릿 변수 치환 도구 |
| `claude-progress.txt` | 세션 이력 (append-only) |
| `feature_list.json` | 작업 목록 + 상태 |
| `tasks/current_task.json` | 현재 작업 상세 |
| `state/session_summary.json` | 세션 결과 요약 |
| `state/known_issues.json` | 알려진 이슈 |
| `state/qa_tuning_log.json` | QA 품질 추적 |
| `verification/smoke.sh` | 최소 실행 가능 상태 검증 |
| `verification/verify_all.sh` | 전체 검증 통합 |
| `scripts/collect_status.sh` | 상태 수집 |
| `scripts/rollback_last_good.sh` | 롤백 |
| `docs/architecture.md` | 시스템 아키텍처 |
| `docs/runbook.md` | 운영 절차 |
| `docs/quality_gates.md` | 품질 게이트 정의 |
| `docs/harness_assumptions.md` | 하네스 진화 가정 |
| `long_running_agent_harness.md` | 한국어 표준 문서 |
| `long_running_agent_harness_variable_dictionary.md` | 변수 사전 (170+개) |
| `.claude/agents/*.md` | 에이전트 역할 정의 |
| `.claude/skills/*/SKILL.md` | 재사용 가능 절차 |
