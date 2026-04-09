# {{PROJECT_NAME}} 사용 가이드

## 목차

1. [프로젝트 개요](#1-프로젝트-개요)
2. [환경 설정](#2-환경-설정)
3. [세션 운영 방법](#3-세션-운영-방법)
4. [에이전트 역할별 가이드](#4-에이전트-역할별-가이드)
5. [검증 체계](#5-검증-체계)
6. [상태 파일 관리](#6-상태-파일-관리)
7. [복구 절차](#7-복구-절차)
8. [작업 관리](#8-작업-관리)
9. [실전 시나리오](#9-실전-시나리오)
10. [FAQ](#10-faq)

---

## 1. 프로젝트 개요

### 1.1 이 프로젝트는 무엇인가

{{PROJECT_NAME}}은 **장시간 코딩 에이전트 하네스**가 적용된 프로젝트입니다. 하네스는 AI 코딩 에이전트(Claude Code 등)가 여러 세션에 걸쳐 안정적으로 작업할 수 있도록 구조, 규칙, 검증, 복구 체계를 제공합니다.

### 1.2 기술 스택

| 항목 | 값 |
|------|-----|
| 런타임 | {{RUNTIME_TYPE}} |
| 기술 스택 | {{PRIMARY_STACK}} |
| 주 언어 | {{LANGUAGE_MAIN}} |
| 패키지 매니저 | {{PACKAGE_MANAGER}} |
| 기본 브랜치 | {{DEFAULT_BRANCH}} |

### 1.3 핵심 원칙

1. **한 세션, 한 작업** — 세션당 하나의 bounded work item만 처리
2. **검증 없는 완료 불가** — 실행된 증거만 인정, "looks right"는 불충분
3. **상태는 파일에 기록** — 대화 컨텍스트가 아닌 저장소 파일에 외부화
4. **복구가 우선** — smoke 실패 시 기능 개발보다 복구가 우선

---

## 2. 환경 설정

### 2.1 최초 설정

```bash
cd {{REPOSITORY_NAME}}

# 의존성 설치
{{CMD_INSTALL}}

# 부트스트랩 실행
{{CMD_BOOTSTRAP}}

# 스모크 검증
{{CMD_SMOKE}}
```

### 2.2 개발 서버 실행

```bash
# 앱 실행
{{CMD_DEV}}

# 헬스 체크 확인
curl {{HEALTHCHECK_URL}}
```

### 2.3 테스트 실행

```bash
# 유닛 테스트
{{CMD_TEST_UNIT}}

# 통합 테스트
{{CMD_TEST_INTEGRATION}}

# 린트
{{CMD_LINT}}

# 타입 체크
{{CMD_TYPECHECK}}
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

```bash
# 1. 저장소 루트 확인
pwd

# 2. 진행 상황 읽기
cat {{PROGRESS_FILE_PATH}}

# 3. 작업 목록 읽기
cat {{FEATURE_LIST_FILE_PATH}}

# 4. 현재 작업 확인
cat {{CURRENT_TASK_FILE_PATH}}

# 5. 알려진 이슈 확인
cat {{KNOWN_ISSUES_FILE_PATH}}

# 6. 최근 git 이력
git log --oneline -20

# 7. 부트스트랩
{{CMD_BOOTSTRAP}}

# 8. 스모크 검증
{{CMD_SMOKE}}
# → smoke 실패 시 기능 작업 금지, 복구 우선
```

### 3.3 세션 종료 절차

```bash
# 1. 검증 실행
{{CMD_SMOKE}}

# 2. feature_list.json 상태 업데이트

# 3. claude-progress.txt에 세션 엔트리 추가

# 4. state/session_summary.json 업데이트

# 5. 커밋 (정책 허용 시)
bash ./scripts/commit_session.sh

# 6. 저장소가 다음 세션에서 재개 가능한 상태인지 확인
```

---

## 4. 에이전트 역할별 가이드

### 4.1 Planner (기획)

**파일:** `.claude/agents/planner.md`

**역할:**
- `feature_list.json`과 `tasks/backlog.json`에서 다음 작업 1개 선택
- 범위(in-scope/out-of-scope), 수용 기준, 검증 계획 정의
- `tasks/current_task.json` 생성

**핵심 규칙:**
- "무엇을(what)" 정의하되 "어떻게(how)"는 coder에게 위임
- 파일 목록은 참고용, coder가 실제 파일 결정
- 한 세션에 하나의 작업만 선택
- smoke 실패 시 기능 작업 대신 복구 작업 선택

**출력 예시:**
```json
{
  "task_id": "F-001",
  "title": "작업 제목",
  "in_scope": ["범위 항목 1", "범위 항목 2"],
  "out_of_scope": ["제외 항목 1"],
  "acceptance_criteria": ["검증 가능한 기준 1", "검증 가능한 기준 2"],
  "verification_plan": ["검증 명령 1", "검증 명령 2"]
}
```

### 4.2 Reviewer — Contract Review (계약 검토)

**파일:** `.claude/agents/reviewer.md` — Contract Review Procedure 섹션

**역할 (구현 전):**
- planner가 만든 `current_task.json`의 범위, 수용 기준, 검증 계획을 검토
- 모호한 기준, 검증 불가능한 조건, 과도한 범위를 거부

**결과:**
- `contract_status`: `approved` / `rejected` / `revision_needed`
- 거부 시 planner에게 반환하여 수정

### 4.3 Coder (구현)

**파일:** `.claude/agents/coder.md`

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

**파일:** `.claude/agents/reviewer.md`

**역할 (구현 후):**
- 범위 준수, 정확성, 검증 증거, 회귀 위험 평가
- 가능하면 실행 중인 앱을 직접 테스트 (Runtime Verification)
- 승인(`approved`), 반려(`rejected`), 보류(`pending`) 결정

**QA 튜닝:**
- `[QA-UNCERTAIN]`: 판단이 애매한 부분 표시
- `[QA-RATIONALIZATION-RISK]`: 증거 부족한데 승인하려는 유혹 표시
- 놓친 이슈는 `state/qa_tuning_log.json`에 기록

### 4.5 Initializer (초기화)

**파일:** `.claude/agents/initializer.md`

**역할:**
- 저장소 부트스트랩 절차 정규화
- `init.sh`, `state/environment.json`, 검증 스크립트 정비
- 최초 세션 또는 환경 변경 시 사용

---

## 5. 검증 체계

### 5.1 검증 수준

| 수준 | 명령 | 용도 |
|------|------|------|
| **Smoke** | `{{CMD_SMOKE}}` | 최소 실행 가능 상태 확인 (필수 파일, 프로세스, 포트, 헬스체크) |
| **Unit** | `{{CMD_TEST_UNIT}}` | 단위 테스트 |
| **Integration** | `{{CMD_TEST_INTEGRATION}}` | 통합 테스트 |
| **Lint** | `{{CMD_LINT}}` | 코드 스타일 |
| **Typecheck** | `{{CMD_TYPECHECK}}` | 타입 검사 |
| **Full** | `{{CMD_VERIFY_ALL}}` | 위 모든 검증 통합 실행 |

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
- **core 변경 시 full verify** — 공유 코드 변경 시 `{{CMD_VERIFY_ALL}}` 실행
- **건너뛴 체크는 명시적으로 기록**

---

## 6. 상태 파일 관리

### 6.1 핵심 상태 파일

| 파일 | 역할 | 갱신 시점 |
|------|------|----------|
| `{{PROGRESS_FILE_PATH}}` | 세션별 진행 이력 (append-only) | 매 세션 종료 시 |
| `{{FEATURE_LIST_FILE_PATH}}` | 작업 목록 + 완료 상태 | 작업 상태 변경 시 |
| `{{CURRENT_TASK_FILE_PATH}}` | 현재 세션의 단일 작업 | planner가 선택 시 |
| `{{BACKLOG_FILE_PATH}}` | 장기 작업 후보 | 작업 추가/정리 시 |
| `{{SESSION_SUMMARY_FILE_PATH}}` | 세션 결과 요약 | 매 세션 종료 시 |
| `{{KNOWN_ISSUES_FILE_PATH}}` | 알려진 이슈 레지스트리 | 이슈 발견/해결 시 |
| `{{ENVIRONMENT_FILE_PATH}}` | 런타임 환경 정보 | 환경 변경 시 |
| `state/qa_tuning_log.json` | reviewer QA 효과 추적 | 놓친 이슈 발견 시 |

### 6.2 claude-progress.txt 작성 예시

```
================================================================
Session: {{SESSION_TIMESTAMP}}
Session Type: coding
Project: {{PROJECT_NAME}}
Repository: {{REPOSITORY_NAME}}
Branch: {{DEFAULT_BRANCH}}
================================================================

Selected Work Item: F-001
Goal: 작업 목표 설명

Scope:
- In Scope: 범위 내 항목
- Out of Scope: 범위 외 항목

Files Changed:
- path/to/file.py (신규 또는 수정)

Verification Executed:
- {{CMD_TEST_UNIT}} → passed
- {{CMD_SMOKE}} → passed

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

```bash
# 1. 상태 수집
{{CMD_COLLECT_STATUS}}

# 2. 원인 진단
cat {{STATE_DIR_NAME}}/{{STATUS_REPORT_FILENAME}}

# 3. 복구 시도
# (a) 직접 수정 가능하면 수정
# (b) 불가능하면 롤백
bash ./scripts/rollback_last_good.sh HEAD~1 "smoke failure recovery"

# 4. 복구 후 재검증
{{CMD_SMOKE}}

# 5. known_issues.json에 이슈 기록
```

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
  "verification_commands": ["검증 명령"]
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
  ├─ {{CMD_SMOKE}} → FAILED
  ├─ 기능 작업 시작 금지!
  ├─ {{CMD_COLLECT_STATUS}}
  ├─ 원인 진단 및 해결
  ├─ {{CMD_BOOTSTRAP}} (재시작)
  ├─ {{CMD_SMOKE}} → PASSED
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

`{{REQUIRE_REVIEW_AGENT}} = true`로 설정되어 있으면 필요합니다. 급한 hotfix 등 예외 시 coder가 자기 검토를 수행하되, 반드시 검토 내용을 기록해야 합니다.

### Q: 테스트가 없는 작업도 통과할 수 있나요?

검증 방법은 작업에 따라 다릅니다. 테스트 코드가 아니더라도 "실행된 증거"(smoke 통과, curl 응답 확인, 로그 확인 등)가 있어야 합니다. 증거 없는 완료는 불가합니다.

### Q: 하네스 구조를 프로젝트에 맞게 바꿔도 되나요?

폴더/파일 구조는 고정이 원칙이지만, 검증 단계(verify_all.sh의 enable 플래그)나 정책 변수는 프로젝트에 맞게 조정할 수 있습니다. 구조적 변경이 필요하면 `docs/harness_assumptions.md`의 감사 절차를 통해 결정하세요.

### Q: 여러 에이전트를 동시에 실행할 수 있나요?

`{{ALLOW_PARALLEL_TASKS}} = false`이면 불가합니다. 한 번에 하나의 세션, 하나의 작업이 원칙입니다.

### Q: 하네스의 규칙이 너무 엄격하면 어떻게 하나요?

`docs/harness_assumptions.md`에서 각 규칙이 어떤 모델 한계를 가정하는지 확인하세요. 모델이 개선되어 해당 가정이 더 이상 유효하지 않다면, Harness Audit Session을 통해 규칙을 완화할 수 있습니다.

---

## 부록: 주요 파일 경로 요약

| 파일 | 용도 |
|------|------|
| `AGENTS.md` | 하네스 운영 정책 (모든 규칙의 기준) |
| `init.sh` | 부트스트랩 진입점 |
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
| `.claude/agents/*.md` | 에이전트 역할 정의 |
| `.claude/skills/*/SKILL.md` | 재사용 가능 절차 |
