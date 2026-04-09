---
name: regression-check
description: >
  Evaluates whether a bounded implementation or bug-fix session introduced regressions,
  using task-aware verification evidence, repository state checks, and explicit risk recording.
version: {{SKILL_VERSION}}
owner_role: reviewer
applicability:
  - regression-check
  - post-implementation-validation
  - post-bugfix-validation
  - approval-gate
  - long-running-agent-harness
tags:
  - regression
  - validation
  - review
  - quality-gate
  - risk-control
---

# Regression Check Skill

## 1. Purpose

This skill standardizes how regression risk is checked after a bounded session result.

Use this skill to determine whether a task that appears correct has also remained **safe with respect to surrounding behavior**.

This skill exists to prevent:
- narrow fixes that break adjacent flows,
- false approvals based only on task-local success,
- hidden side effects,
- incomplete risk tracking,
- unrecorded degradation of repository health.

---

## 2. When To Use

Use this skill when one or more of the following is true:

1. a feature task completed and touched shared code,
2. a bugfix claims success but might affect adjacent behavior,
3. a reviewer needs explicit regression assessment,
4. a core or shared runtime area changed,
5. verification passed locally but broader impact is uncertain,
6. repository policy requires explicit regression gating before approval.

Typical cases:
- shared component change
- API contract change
- state management change
- routing or auth flow change
- persistence layer modification
- startup/bootstrap path change
- bugfix in widely used logic

---

## 3. When Not To Use

Do not use this skill as the primary action when:

1. the task is still unimplemented,
2. baseline smoke is already failing for unrelated reasons,
3. the repository still lacks bootstrap/verification setup,
4. the work is purely planning,
5. the selected task is too incomplete for meaningful regression assessment.

In those cases:
- complete initialization,
- finish bounded implementation,
- or recover baseline first.

---

## 4. Inputs

This skill expects the following artifacts:

- `{{AGENTS_FILE_PATH}}`
- `{{ENVIRONMENT_FILE_PATH}}`
- `{{PROGRESS_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`
- `{{KNOWN_ISSUES_FILE_PATH}}`
- `{{SESSION_SUMMARY_FILE_PATH}}`

It may also inspect:
- `{{SMOKE_REPORT_FILE_PATH}}`
- `{{VERIFY_ALL_REPORT_FILE_PATH}}`
- git diff
- changed tests
- changed file cluster
- recent commits
- known flaky areas
- previous regressions linked to the same module

---

## 5. Expected Outputs

This skill should produce or update:

### Required
- regression assessment in `{{SESSION_SUMMARY_FILE_PATH}}`
- review or task notes reflecting regression status

### When risk or failures are discovered
- `{{KNOWN_ISSUES_FILE_PATH}}`
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`

### Optional
- explicit regression note appended to `{{PROGRESS_FILE_PATH}}`

The output should always classify:
- regression risk level,
- evidence basis,
- follow-up requirement,
- approval impact.

---

## 6. Regression Principles

### 6.1 Task Success Is Not Enough
A task can satisfy its local acceptance criteria and still regress adjacent behavior.

### 6.2 Check the Changed Surface
Regression assessment should focus on the actual changed surface and its nearest dependencies.

### 6.3 Use the Narrowest Evidence That Covers the Risk
Do not run unrelated checks without reason, but do not skip essential adjacent checks.

### 6.4 Record Risk Explicitly
Regression uncertainty must be written down rather than silently ignored.

### 6.5 Approval Depends on Unresolved Risk
High or unbounded regression risk should affect review outcome.

---

## 7. Required Variables

The following variables must be available or resolvable:

### Paths
- `{{AGENTS_FILE_PATH}}`
- `{{ENVIRONMENT_FILE_PATH}}`
- `{{PROGRESS_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`
- `{{KNOWN_ISSUES_FILE_PATH}}`
- `{{SESSION_SUMMARY_FILE_PATH}}`
- `{{SMOKE_REPORT_FILE_PATH}}`
- `{{VERIFY_ALL_REPORT_FILE_PATH}}`

### Commands
- `{{CMD_SMOKE}}`
- `{{CMD_TEST_UNIT}}`
- `{{CMD_TEST_INTEGRATION}}`
- `{{CMD_TEST_E2E}}`
- `{{CMD_VERIFY_ALL}}`
- `{{CMD_REGRESSION_CHECK_1}}`
- `{{CMD_REGRESSION_CHECK_2}}`
- `{{CMD_REGRESSION_CHECK_3}}`

### Policy
- `{{REQUIRE_FULL_VERIFY_FOR_CORE_CHANGE}}`
- `{{REQUIRE_REVIEW_AGENT}}`
- `{{SESSION_MAX_SCOPE}}`
- `{{REGRESSION_RISK_THRESHOLD_FOR_REJECTION}}`
- `{{REGRESSION_RISK_THRESHOLD_FOR_PENDING}}`

---

## 8. Step-by-Step Procedure

### Step 1. Load Task and Change Context
Read:
- current task
- progress
- session summary
- known issues
- verification reports

Determine:
- what changed,
- which files changed,
- whether the change touched shared areas,
- which adjacent behaviors are at risk.

### Step 2. Identify Regression Surface
Map the changed area to likely regression zones, such as:
- sibling user flows
- dependent modules
- shared components
- shared service calls
- startup/health behavior
- API contracts
- persistence format
- auth/session state
- background jobs

### Step 3. Review Existing Verification Coverage
Check whether already executed verification meaningfully covers:
- the changed behavior,
- the nearest adjacent behavior,
- the shared/runtime surface if changed.

If not, require additional regression-oriented checks.

### Step 4. Run Focused Regression Checks
Run the most relevant checks available, such as:
- smoke
- adjacent unit tests
- nearby integration tests
- end-to-end path checks
- contract/schema checks
- configured regression commands

Use full verification when policy or changed surface requires it.

### Step 5. Assess Residual Risk
Classify residual regression risk as:
- low
- medium
- high
- unknown

Base this on:
- change surface size
- verification breadth
- known flakiness
- unresolved adjacent uncertainty
- issue history

### Step 6. Record Findings
Write:
- regression findings
- affected areas checked
- checks executed
- remaining blind spots
- risk level
- follow-up requirements

### Step 7. Influence Review Outcome
If risk is above policy threshold:
- reject,
- or set pending,
- or require explicit follow-up task.

Do not approve as fully passed while material regression uncertainty remains hidden.

---

## 9. Regression Surface Rules

Assess regression risk by the smallest meaningful affected surface first.

Common surfaces:
- same file / same function
- same module / same route
- same state transition
- same API contract
- same UI flow
- same worker lifecycle
- same persistence boundary

Do not jump to repository-wide fear without evidence.
Do not reduce broad shared changes to “local only” without evidence either.

---

## 10. Verification Mapping Rules

Choose the narrowest check that meaningfully covers adjacent risk.

### Smoke
Use for:
- baseline readiness
- startup/health regressions
- broad minimum availability

### Unit
Use for:
- logic neighbor regressions
- helper / parser / transform regressions

### Integration
Use for:
- service interaction regressions
- data exchange regressions
- module boundary regressions

### E2E
Use for:
- user-flow regressions
- end-to-end path regressions

### Full Verification
Use when:
- shared runtime changed
- contract/state boundary changed
- policy requires it
- risk surface is broad

### Custom Regression Checks
Use:
- `{{CMD_REGRESSION_CHECK_1}}`
- `{{CMD_REGRESSION_CHECK_2}}`
- `{{CMD_REGRESSION_CHECK_3}}`

only when relevant and configured.

---

## 11. Risk Classification Rules

### Low Risk
Use when:
- changed surface is small,
- relevant checks ran,
- no adjacent failure signal exists,
- no known issue suggests further spread.

### Medium Risk
Use when:
- changed surface is moderate,
- partial adjacent checks ran,
- some uncertainty remains,
- but no concrete failure is present.

### High Risk
Use when:
- shared/core area changed,
- relevant adjacent checks are missing,
- known issues suggest spread,
- regression symptoms exist,
- or verification coverage is materially insufficient.

### Unknown Risk
Use when:
- evidence is too incomplete to classify safely.

Do not collapse unknown into low.

---

## 12. Artifact Update Rules

### session_summary.json
Update:
- regression risk
- regression findings
- quality gate result
- follow-up requirement

### current_task.json
Update when regression findings affect:
- review status
- blocked state
- handoff notes

### known_issues.json
Update when:
- regression is confirmed,
- regression suspicion must be tracked,
- adjacent behavior failure is discovered.

### feature_list.json / backlog.json
Update if a follow-up regression task must be created.

---

## 13. Approval Impact Rules

Use regression findings to influence approval.

### Approve
Only if:
- regression risk is acceptable,
- relevant checks ran,
- no blocking adjacent failure is present.

### Pending
Use if:
- implementation is probably correct,
- but regression evidence is incomplete,
- and policy requires more certainty.

### Reject
Use if:
- regression is confirmed,
- or regression risk is materially too high,
- or approval would hide unsafe uncertainty.

---

## 14. Output Template

Use this structure after applying the skill:

### Reviewed Task
- `{{WORK_ITEM_ID}}`
- `{{WORK_ITEM_TITLE}}`

### Changed Surface
- {{CHANGED_SURFACE_1}}
- {{CHANGED_SURFACE_2}}

### Regression Checks Executed
- {{REGRESSION_CHECK_1}}
- {{REGRESSION_CHECK_2}}
- {{REGRESSION_CHECK_3}}

### Findings
- {{FINDING_1}}
- {{FINDING_2}}
- {{FINDING_3}}

### Residual Risk
- {{REGRESSION_RISK_LEVEL}}

### Approval Impact
- {{APPROVAL_IMPACT}}

### Required Follow-up
- {{FOLLOWUP_1}}
- {{FOLLOWUP_2}}

---

## 15. Do Not Rules

- Do not assume task-local success implies no regression.
- Do not ignore changed shared surfaces.
- Do not classify risk as low without evidence.
- Do not hide unknown risk.
- Do not approve while a likely regression is untracked.
- Do not require unrelated broad checks without reason.
- Do not leave regression concerns only in narrative text.

---

## 16. Success Definition

This skill succeeds when:

1. changed surface is analyzed,
2. adjacent risk is checked,
3. relevant regression evidence is collected,
4. residual risk is classified,
5. artifacts reflect the result,
6. approval impact is explicit.

---

## 17. Notes

This skill is intended to be reused by:
- reviewer agent
- post-feature review
- post-bugfix validation
- approval-gate flows
- quality gate sessions

It is not a substitute for implementation or general planning.
It is a focused regression risk assessment skill.