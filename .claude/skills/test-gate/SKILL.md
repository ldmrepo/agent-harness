---
name: test-gate
description: >
  Enforces the repository's verification gate for bounded sessions by evaluating
  required test scope, execution evidence, pass/fail status, and gate impact on task approval.
version: {{SKILL_VERSION}}
owner_role: reviewer
applicability:
  - verification-gate
  - approval-gate
  - session-close-gate
  - long-running-agent-harness
tags:
  - test-gate
  - verification
  - approval
  - quality-gate
  - session-close
---

# Test Gate Skill

## 1. Purpose

This skill standardizes how the repository decides whether a session has passed the required **verification gate**.

Use this skill to determine whether:
- the right checks were selected,
- the checks actually ran,
- the results justify approval,
- missing or failed checks should block task completion.

This skill exists to prevent:
- unverified completion claims,
- partial test evidence being treated as full approval,
- incorrect use of smoke as a substitute for deeper checks,
- inconsistent gate decisions across sessions.

---

## 2. When To Use

Use this skill when one or more of the following is true:

1. a coding session is ending,
2. a task is being considered for `verified` or `passed`,
3. review requires explicit verification gate evaluation,
4. core/shared code changed,
5. a bugfix claims resolution,
6. repository policy requires verification before approval.

Typical uses:
- feature completion gate
- bugfix completion gate
- core-change verification gate
- pre-review verification decision
- post-review evidence check

---

## 3. When Not To Use

Do not use this skill as the primary action when:

1. the task is still in planning,
2. the repository has not been bootstrapped,
3. the selected task has not reached an implementation checkpoint,
4. no verification path exists yet because the task must first be broken down,
5. the repository is blocked by unrelated recovery work.

In those cases, use:
- repo-bootstrap,
- task-breakdown,
- feature-implementation,
- or recovery flow first.

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
- changed tests
- recent git diff
- recent commits
- prior rejection notes
- runtime logs when verification results are ambiguous

---

## 5. Expected Outputs

This skill should produce or update:

### Required
- verification gate outcome in `{{SESSION_SUMMARY_FILE_PATH}}`
- verification-related review/task status in `{{CURRENT_TASK_FILE_PATH}}`

### When task state changes
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`

### When failures reveal issues
- `{{KNOWN_ISSUES_FILE_PATH}}`

### Optional
- verification note appended to `{{PROGRESS_FILE_PATH}}`

The result should always make it explicit whether the task is:
- gate-passed,
- gate-failed,
- gate-pending,
- or not yet eligible for gate evaluation.

---

## 6. Test Gate Principles

### 6.1 Required Checks Must Match the Task
Verification depth must fit the task’s actual change surface and repository policy.

### 6.2 Executed Evidence Beats Planned Intent
Only executed checks count toward the gate.
Planned-but-not-run checks do not satisfy the gate.

### 6.3 Smoke Is Necessary but Often Not Sufficient
Smoke proves baseline readiness.
It does not automatically prove feature correctness or regression safety.

### 6.4 Gate Decisions Must Be Explicit
A task either passed the gate, failed it, or still needs evidence.
Do not blur these states.

### 6.5 Artifact Consistency Is Part of the Gate
Gate outcome must be reflected consistently across current task, session summary, and task status artifacts.

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
- `{{CMD_TEST_GATE_EXTRA_1}}`
- `{{CMD_TEST_GATE_EXTRA_2}}`

### Policy
- `{{REQUIRE_REVIEW_AGENT}}`
- `{{REQUIRE_FULL_VERIFY_FOR_CORE_CHANGE}}`
- `{{VERIFY_ALL_RUN_SMOKE_FIRST}}`
- `{{VERIFY_ENABLE_LINT}}`
- `{{VERIFY_ENABLE_TYPECHECK}}`
- `{{VERIFY_ENABLE_UNIT}}`
- `{{VERIFY_ENABLE_INTEGRATION}}`
- `{{VERIFY_ENABLE_E2E}}`
- `{{VERIFY_ENABLE_BUILD}}`
- `{{TEST_GATE_POLICY_LEVEL}}`

---

## 8. Step-by-Step Procedure

### Step 1. Load Verification Context
Read:
- current task
- progress log
- session summary
- verification reports
- known issues

Determine:
- selected task
- task type
- verification type
- declared verification plan
- executed verification evidence
- claimed result

### Step 2. Determine Required Gate Depth
Based on task and policy, decide what the minimum gate requires:
- smoke only
- smoke + task-level tests
- smoke + integration/e2e
- full verify_all
- additional custom gate checks

### Step 3. Compare Planned vs Executed Checks
Check:
- which commands were planned
- which commands were actually run
- which passed / failed / were skipped
- whether required commands are missing

### Step 4. Validate the Evidence Quality
Evaluate whether the executed checks meaningfully support:
- task correctness
- runtime safety
- regression confidence
- approval readiness

### Step 5. Classify Gate Outcome
Set one of:
- passed
- failed
- pending
- not_evaluable

### Step 6. Record Gate Impact
Write:
- gate result
- missing evidence if any
- failed evidence if any
- whether task can move to `verified` or `passed`
- whether review can continue or must stop

---

## 9. Gate Depth Rules

### Smoke Gate
Use as minimum baseline when:
- repository must be runnable,
- task affects runtime readiness,
- no deeper verification is applicable.

### Task-Level Gate
Use when:
- the task changes isolated logic or a bounded feature,
- relevant unit/integration/e2e checks exist.

### Full Verification Gate
Use when:
- shared/core code changed,
- repository policy requires it,
- broad regression surface exists,
- task explicitly requires `verify_all`.

### Extended Gate
Use when:
- repository has additional required gate commands,
- security/schema/build/perf checks are part of approval policy.

---

## 10. Gate Outcome Rules

### passed
Use when:
- required checks ran,
- required checks passed,
- evidence supports the task claim,
- no blocking verification gap remains.

### failed
Use when:
- required check failed,
- required check result contradicts approval,
- missing check is treated as blocking by policy.

### pending
Use when:
- implementation may be correct,
- but one or more required non-failing checks still need to run,
- or evidence is incomplete but not yet contradictory.

### not_evaluable
Use when:
- verification setup is missing,
- artifacts are too incomplete to judge,
- the repository has not reached a meaningful gate point.

Do not collapse `pending` or `not_evaluable` into `passed`.

---

## 11. Verification Evidence Rules

Only count evidence that is:
- executed,
- relevant,
- recorded,
- attributable to the selected session/task,
- understandable from artifacts or reports.

Evidence is weaker when:
- command history is missing,
- results are only described narratively,
- skipped checks are unlabeled,
- reports contradict task status.

Do not assume a check passed because no failure was mentioned.

---

## 12. Artifact Update Rules

### current_task.json
Update:
- executed verification commands
- verification result
- review/gate-related notes
- status if gate outcome changes task eligibility

### session_summary.json
Update:
- verification findings
- quality gate outcome
- follow-up requirement
- clean-state implications if relevant

### feature_list.json / backlog.json
Update only if gate result changes the task lifecycle state.

### known_issues.json
Update when:
- verification failure reveals a new issue,
- flaky or broken test infrastructure must be tracked,
- a blocked gate is caused by a persistent defect.

---

## 13. Approval Impact Rules

The test gate should influence approval as follows:

### Gate Passed
- reviewer may continue or approve if other criteria are also satisfied

### Gate Failed
- approval should normally be rejected

### Gate Pending
- reviewer should normally hold approval as pending

### Gate Not Evaluable
- task should not be treated as verified/passed

Do not mark a task `passed` when the test gate outcome is not passed.

---

## 14. Output Template

Use this structure after applying the skill:

### Reviewed Task
- `{{WORK_ITEM_ID}}`
- `{{WORK_ITEM_TITLE}}`

### Required Gate Depth
- {{REQUIRED_GATE_DEPTH}}

### Checks Executed
- {{EXECUTED_CHECK_1}}
- {{EXECUTED_CHECK_2}}
- {{EXECUTED_CHECK_3}}

### Missing or Failed Checks
- {{MISSING_OR_FAILED_CHECK_1}}
- {{MISSING_OR_FAILED_CHECK_2}}

### Gate Result
- {{TEST_GATE_RESULT}}

### Approval Impact
- {{APPROVAL_IMPACT}}

### Required Follow-up
- {{FOLLOWUP_1}}
- {{FOLLOWUP_2}}

---

## 15. Do Not Rules

- Do not treat planned checks as executed checks.
- Do not treat smoke as sufficient when deeper checks are required.
- Do not approve while gate-required evidence is missing.
- Do not hide failed checks behind narrative summaries.
- Do not leave gate outcome implicit.
- Do not mark tasks passed when the gate is pending or not evaluable.

---

## 16. Success Definition

This skill succeeds when:

1. required verification depth is identified,
2. executed evidence is checked,
3. gate outcome is explicitly classified,
4. artifact state reflects the gate result,
5. approval impact is made explicit,
6. next action is clear.

---

## 17. Notes

This skill is intended to be reused by:
- reviewer agent
- verification gate sessions
- approval pipelines
- session-close quality gates
- pass-state validation loops

It is not a substitute for implementation or regression analysis.
It is a verification gate decision skill.