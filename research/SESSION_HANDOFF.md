# 세션 핸드오프 — 2026-04-10

## 프로젝트: agent-harness

**GitHub:** https://github.com/ldmrepo/agent-harness
**위치:** `/Users/ldm/work/agent-harness`

---

## 프로젝트 구조

```
agent-harness/
├── template/          ← 신규 프로젝트에 cp -r로 복사하는 하네스 템플릿
├── specs/             ← 한국어 설계 표준 문서
├── research/          ← 분석, 계획, 대시보드 목업
├── reference/         ← claude-docs 참조 문서
├── USAGE_GUIDE.md     ← 하네스 적용 가이드
└── README.md
```

---

## 완료된 작업

### 1. 문서 체계 개선
- 한국어 문서 2개 마크다운 표준화 (⸻→---, 헤딩/불릿 수정)
- 변수 사전 171개 변수 신규 등록 (598→1677줄)
- 셸 스크립트 버그 4건 수정 (JSON escape, bare boolean, 타임스탬프)
- README.md, .gitignore, USAGE_GUIDE.md 생성
- `scripts/_common.sh` 공통 유틸리티 추출, 7개 스크립트 리팩토링

### 2. Anthropic 하네스 원칙 정합성 (10/10 충족)
- Sprint Contract: reviewer 사전 합의 단계 추가 (AGENTS.md, planner/reviewer/coder.md, current_task.json, quality_gates.md)
- Harness Evolution: `docs/harness_assumptions.md` 신규 + architecture.md, runbook.md 갱신
- Planner 추상화: Abstraction Level Principle, optional 핸드오프, Do Not Rule 추가
- QA 튜닝: `state/qa_tuning_log.json` + reviewer QA Tuning Responsibilities
- Runtime Verification: reviewer Runtime Verification Procedure + `REVIEWER_ENABLE_RUNTIME_VERIFICATION` 변수

### 3. Claude Code 통합
- `.claude/settings.json` — 7개 Hook 이벤트 설정
- `.claude/hooks/` — 5개 스크립트:
  - `block-dangerous-commands.sh` (rm -rf, git push --force 차단)
  - `check-smoke-before-edit.sh` (smoke 실패 시 앱 코드 차단)
  - `check-contract-before-edit.sh` (contract 미승인 시 차단)
  - `stop-progress-gate.sh` (progress 미기록 시 종료 차단)
  - `post-edit-verify.sh` (자동 린트, async)
- `.claude/rules/` — 3개 역할별 규칙 (planner, coder, reviewer)
- `orchestrator.sh` — CLI 헤드리스 모드 기반 자동 세션 순환

### 4. 코드 리뷰 개선
- stdin 조기 소비 (3개 hook)
- rm 패턴 강화 (-r -f 분리 플래그)
- orchestrator blocked 상태 분기 추가
- settings.json matcher 합치기

### 5. 프로젝트 폴더 정리
- template/ / specs/ / research/ / reference/ 4개 영역 분리

### 6. 장기 자율 분석
- `research/long_term_autonomous_analysis.md` 작성
- 5계층 아키텍처 정의 (전술/전략/에스컬레이션/감시/대시보드)

### 7. 샘플 프로젝트
- `/Users/ldm/work/sample-todo-api` — FastAPI + SQLite TODO API
- configure.sh로 128개 변수 치환 완료
- feature_list.json에 F-001~F-003 작업 등록
- USAGE_GUIDE.md 사용 가이드 작성

---

## 진행 중인 작업: 대시보드 목업

**파일:** `research/dashboard-mockup/index.html`

### 현재 상태
- 6개 섹션으로 재구성 완료 (실제 데이터 소스 기반)
- 미구현 기능 의존 섹션 모두 제거 (마일스톤, 에스컬레이션, 비용)
- 디자인: Share Tech Mono + Roboto Condensed, warm stone 라이트 테마, 다크 잉크

### 현재 6개 섹션
1. **현재 상태 패널** — task, agent, contract, smoke, verification (current_task.json)
2. **KPI 4개** — 완료/전체, 반려 수, 이슈 수, QA 놓침
3. **작업 파이프라인** — feature_list.json의 작업 목록 + 상태 + 의존성
4. **세션 타임라인** — claude-progress.txt에서 최근 이벤트
5. **Smoke Checks** — smoke_report.json 개별 체크 결과
6. **Known Issues** — known_issues.json severity별

### 다음 할 일: 모니터링 강화
상단 상태 패널에 추가 필요:
- **Orchestrator 진행**: 세션 N/M, 경과/최대 시간
- **현재 작업 체류**: "이 작업 N세션째" (같은 task_id의 progress 카운트)
- **Smoke 이력**: 최근 8회 ✓✗ 패턴
- **연속 실패 카운터**: 0/3 (3이면 자동 중단)

---

## 디자인 설정

```css
--display: 'Share Tech Mono'     /* 숫자, KPI */
--body: 'Roboto Condensed'       /* 본문 */
--code: 'IBM Plex Mono'          /* 코드, 메타 */
--t-sm: 16px                     /* 최소 폰트 */
--t-base: 18px                   /* 본문 */
--t-2xl: 44px                    /* KPI 숫자 */
--ink-1: #0a0908                 /* 거의 블랙 */
--ink-2: #1a1816                 /* 진한 다크 */
--ink-3: #2e2a26                 /* 다크 그레이 */
```

---

## Git 커밋 이력 (주요)

```
83c908a refactor: reorganize project into template/specs/research/reference
095e821 fix: address code review findings for hooks and orchestrator
5136d29 feat: Claude Code integration — hooks, rules, orchestrator
0d944b5 docs: rewrite USAGE_GUIDE.md as harness guide without template variables
4d57173 docs: add USAGE_GUIDE.md template for new projects
a3b5db4 docs: add Claude Code reference documentation
89bc80a Initial commit: Long-running coding agent harness template
```
