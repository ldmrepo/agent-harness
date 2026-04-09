---
name: code-review-checklist
description: >
  Applies a structured evidence-based review checklist for bounded session results,
  validating scope, correctness, verification, artifact consistency, and resumable repository state.
version: {{SKILL_VERSION}}
owner_role: reviewer
applicability:
  - review
  - approval-gate
  - rejection-gate
  - bounded-session-review
  - long-running-agent-harness
tags:
  - review
  - checklist
  - approval
  - verification
  - quality-gate
---

# Code Review Checklist Skill

## 1. Purpose

This skill standardizes how a completed coding session is reviewed before approval.

Use this skill to make review decisions:
- explicit,
- evidence-based,
- scope-aware,
- verification-aware,
- artifact-consistent,
- safe for handoff or merge.

This skill exists to prevent:
- approval from narrative alone,
- missing verification,
- hidden scope drift,
- artifact inconsistency,
- unsafe “done” claims.

---

## 2. When To Use

Use this skill when one or more of the following is true:

1. a bounded implementation session has completed,
2. a task claims `passed` or `verified`,
3. review is required by policy,
4. a rejected task is being re-reviewed,
5. a core change requires explicit approval,
6. a session summary and verification artifacts are available for assessment.

Typical uses:
- feature review
- bugfix approval
- regression fix review
- pre-pass gate
- reviewer agent decision step

---

## 3. When Not To Use

Do not use this skill as the primary action when:

1. the current work is still in planning,
2. the repository has not yet been initialized,
3. the task has not reached an implementation checkpoint,
4. required baseline artifacts are missing and review cannot be meaningfully performed,
5. the main need is recovery rather than approval.

In those cases, use:
- planning,
- initialization,
- implementation,
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
- smoke report
- verify_all report
- git diff
- recent commits
- changed tests
- generated artifacts
- previous rejection notes
- runtime or error logs if needed

---

## 5. Expected Outputs

This skill should produce or update:

### Required
- review decision in `{{CURRENT_TASK_FILE_PATH}}`
- review notes in `{{SESSION_SUMMARY_FILE_PATH}}`

### When state changes
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`

### When issues are discovered
- `{{KNOWN_ISSUES_FILE_PATH}}`

### Optional
- review note appended to `{{PROGRESS_FILE_PATH}}`

The result should always make the next action obvious:
- approve
- reject
- pending
- recovery required

---

## 6. Review Principles

### 6.1 Review Scope Before Quality
First verify whether the work matches the selected task.
Quality judgment without scope alignment is incomplete.

### 6.2 Evidence Over Confidence
Claims of completion must be backed by:
- artifact state,
- verification results,
- diff inspection,
- explicit notes.

### 6.3 Verification Is a Gate
Required verification must be present and relevant.

### 6.4 Artifact Consistency Matters
Task state, session summary, progress, and issue records must not contradict each other.

### 6.5 Resumability Is Part of Approval
A session result is weaker if the repository cannot be resumed safely by the next session.

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

### Policy
- `{{SESSION_MAX_SCOPE}}`
- `{{REQUIRE_REVIEW_AGENT}}`
- `{{REQUIRE_FULL_VERIFY_FOR_CORE_CHANGE}}`

---

## 8. Step-by-Step Procedure

### Step 1. Load Review Context
Read:
- current task
- progress log
- session summary
- known issues
- feature list
- verification reports

Identify:
- selected task
- task type
- acceptance criteria
- review requirement
- claimed result
- verification claimed

### Step 2. Confirm Task Identity
Check that the reviewed implementation clearly corresponds to the selected work item.

If the implementation appears to solve a different task or multiple tasks, flag scope drift.

### Step 3. Review Scope Compliance
Check:
- planned scope vs actual scope
- out-of-scope violations
- expected files vs actual files
- whether unexpected files changed and why

### Step 4. Review Correctness Claims
Check whether the implementation appears to satisfy:
- stated acceptance criteria
- intended behavior
- task description
- bugfix expectation when relevant

### Step 5. Review Verification Evidence
Check:
- what verification was planned
- what verification was executed
- what passed / failed / was skipped
- whether the right level of verification was used
- whether full verification was required and performed

### Step 6. Review Repository State
Check:
- smoke state
- blocked state
- known issues introduced
- clean-state claim
- resumability for next session

### Step 7. Decide Review Outcome
Set one of:
- approved
- rejected
- pending
- not_required

### Step 8. Write Review Notes
Record:
- decision
- reasons
- evidence references
- follow-up requirements
- issue updates if needed

---

## 9. Checklist Categories

Use the following checklist categories for every review.

### 9.1 Scope Checklist
- [ ] selected task is clearly identified
- [ ] implementation stays within selected scope
- [ ] out-of-scope rules are respected
- [ ] unexpected files changed only with justification
- [ ] work remains within `{{SESSION_MAX_SCOPE}}`

### 9.2 Correctness Checklist
- [ ] acceptance criteria are addressed
- [ ] claimed behavior matches repository changes
- [ ] no obvious contradiction exists between code and task claim
- [ ] bugfix claim addresses actual defect path when relevant

### 9.3 Verification Checklist
- [ ] smoke result is known
- [ ] feature-level verification is known
- [ ] full verification status is known when applicable
- [ ] skipped checks are explicitly labeled
- [ ] verification evidence supports the claimed result

### 9.4 Artifact Consistency Checklist
- [ ] current task state is updated
- [ ] progress entry reflects what changed
- [ ] session summary reflects verification and result
- [ ] feature/backlog status is consistent
- [ ] known issues are updated if needed

### 9.5 Repository State Checklist
- [ ] repository is resumable
- [ ] no hidden blocker remains
- [ ] clean-state claim is justified
- [ ] next step is inferable from artifacts

---

## 10. Approval Rules

Approve only when all required conditions are met.

A result can be approved when:
1. task identity is clear,
2. scope compliance is acceptable,
3. acceptance criteria are satisfied,
4. required verification is present,
5. artifact state is consistent,
6. no blocking issue invalidates the result,
7. repository state is resumable.

If `{{REQUIRE_REVIEW_AGENT}} = true`, lack of review completion blocks pass approval.

---

## 11. Rejection Rules

Reject when any of the following is true:

1. selected scope was violated,
2. acceptance criteria are not actually satisfied,
3. required verification is missing,
4. verification failed,
5. task/artifact states contradict each other,
6. a blocking issue remains hidden or unresolved,
7. repository is not cleanly resumable,
8. regression risk is unacceptably high without mitigation.

A rejection must include:
- specific reason,
- artifact or evidence basis,
- recommended corrective next step.

---

## 12. Pending Rules

Use `pending` only when:
- implementation appears close,
- but required review evidence is incomplete,
- or one essential non-blocking check remains,
- or a policy gate is awaiting completion.

Do not use pending as a substitute for clear rejection.

---

## 13. Known Issue Handling

If review uncovers:
- a new regression,
- a missing issue record,
- hidden blocker,
- flaky verification,
- untracked limitation,

update or require update to `{{KNOWN_ISSUES_FILE_PATH}}`.

Do not approve while a significant unrecorded issue remains.

---

## 14. Output Template

Use this structure after applying the skill:

### Reviewed Task
- `{{WORK_ITEM_ID}}`
- `{{WORK_ITEM_TITLE}}`

### Review Decision
- {{REVIEW_STATUS}}

### Scope Findings
- {{SCOPE_FINDING_1}}
- {{SCOPE_FINDING_2}}

### Correctness Findings
- {{CORRECTNESS_FINDING_1}}
- {{CORRECTNESS_FINDING_2}}

### Verification Findings
- {{VERIFICATION_FINDING_1}}
- {{VERIFICATION_FINDING_2}}
- {{VERIFICATION_FINDING_3}}

### Artifact Findings
- {{ARTIFACT_FINDING_1}}
- {{ARTIFACT_FINDING_2}}

### Required Follow-up
- {{FOLLOWUP_1}}
- {{FOLLOWUP_2}}
- {{FOLLOWUP_3}}

---

## 15. Do Not Rules

- Do not approve from conversational confidence alone.
- Do not ignore missing verification.
- Do not ignore artifact inconsistency.
- Do not silently reinterpret the task to justify approval.
- Do not hide regression risk to preserve momentum.
- Do not mark approved when the result is only partially supported.
- Do not treat missing evidence as passing evidence.

---

## 16. Success Definition

This skill succeeds when:

1. review outcome is explicit,
2. outcome reasons are explicit,
3. scope correctness and verification are all checked,
4. artifact consistency is assessed,
5. repository resumability is assessed,
6. the next action is unambiguous.

---

## 17. Notes

This skill is intended to be reused by:
- reviewer agent
- approval gate sessions
- rejection and re-review cycles
- pass-state validation loops

It is not a substitute for implementation or planning.
It is an evidence-based review gate skill.