---
name: feature-implementation
description: >
  Implements a selected bounded feature task within the long-running harness,
  respecting current-task scope, verification requirements, artifact updates, and clean-state handoff rules.
version: {{SKILL_VERSION}}
owner_role: coder
applicability:
  - feature-implementation
  - bounded-coding-session
  - current-task-execution
  - long-running-agent-harness
tags:
  - implementation
  - coding
  - feature
  - verification
  - handoff
---

# Feature Implementation Skill

## 1. Purpose

This skill standardizes how a selected feature task is implemented in a **single bounded coding session**.

Use this skill to ensure that feature work is:
- scoped,
- verifiable,
- recorded in artifacts,
- safe to hand off,
- consistent with harness policy.

This skill exists to prevent:
- uncontrolled scope expansion,
- incomplete verification,
- hidden partial work,
- inconsistent task state,
- poor reviewer handoff.

---

## 2. When To Use

Use this skill when all of the following are true:

1. a current task has already been selected,
2. the task is implementation-oriented,
3. the scope is bounded,
4. acceptance criteria exist,
5. a verification path exists,
6. runtime state is healthy enough to proceed.

Typical task types:
- feature
- bugfix
- bounded refactor tied to feature behavior
- UI behavior update
- API behavior update
- integration task with clear verification

---

## 3. When Not To Use

Do not use this skill as the primary action when:

1. the repository still needs initialization,
2. smoke is failing and the selected task is not recovery,
3. the current task is too large or ambiguous,
4. the primary job is review rather than implementation,
5. the task lacks verification readiness.

In those cases, use:
- repo-bootstrap,
- task-breakdown,
- or a recovery-oriented skill first.

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

It may also inspect:
- recent git history,
- previous session summary,
- smoke report,
- verify_all report,
- current diffs,
- related tests,
- reviewer notes if the task is rework.

---

## 5. Expected Outputs

This skill should produce or update:

### Required
- implementation changes in repository files
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{PROGRESS_FILE_PATH}}`

### When state changes
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`

### When issues are found
- `{{KNOWN_ISSUES_FILE_PATH}}`

### At session close
- `{{SESSION_SUMMARY_FILE_PATH}}`

### Optional
- focused commit, if policy allows

---

## 6. Implementation Principles

### 6.1 Implement Only the Selected Task
The current task is the hard boundary for the session.

### 6.2 Smallest Safe Change Wins
Prefer a small correct change over a broad elegant change.

### 6.3 Verification Is Part of the Task
A feature is not done when code exists.
It is done when required verification has run and the result is recorded.

### 6.4 State Must Be Externalized
Repository progress must be reflected in artifacts, not only in changed code.

### 6.5 Clean-State Ending Is Mandatory
Leave the repo resumable, even when the task is blocked or incomplete.

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

### Commands
- `{{CMD_BOOTSTRAP}}`
- `{{CMD_SMOKE}}`
- `{{CMD_TEST_UNIT}}`
- `{{CMD_TEST_INTEGRATION}}`
- `{{CMD_TEST_E2E}}`
- `{{CMD_VERIFY_ALL}}`

### Policy
- `{{ALLOW_PARALLEL_TASKS}}`
- `{{REQUIRE_FULL_VERIFY_FOR_CORE_CHANGE}}`
- `{{REQUIRE_REVIEW_AGENT}}`
- `{{ALLOW_AUTO_COMMIT}}`
- `{{SESSION_MAX_SCOPE}}`

### Commit Conventions
- `{{COMMIT_PREFIX_FEAT}}`
- `{{COMMIT_PREFIX_FIX}}`
- `{{COMMIT_PREFIX_CHORE}}`

---

## 8. Step-by-Step Procedure

### Step 1. Load Current Task and Session Context
Read:
- progress log,
- current task,
- feature list,
- known issues,
- environment info.

Determine:
- exact work item,
- accepted scope,
- out-of-scope boundaries,
- expected files,
- verification type,
- blockers or caveats.

### Step 2. Establish Runnable Baseline
Run:
- `{{CMD_BOOTSTRAP}}`
- `{{CMD_SMOKE}}`

If smoke fails and the current task is not recovery, do not proceed as normal feature work.

### Step 3. Plan Minimal Change Path
Before editing code, identify:
- smallest target file set,
- likely test surface,
- highest regression risk area,
- whether adjacent changes are truly necessary.

### Step 4. Implement Scoped Changes
Modify only what is required to satisfy the selected task.

If unexpected files must change:
- keep the change minimal,
- record the reason in artifacts,
- do not let the task silently expand.

### Step 5. Update or Add Verification
Add or adjust tests when needed so the task can be verified at the appropriate layer.

### Step 6. Run Required Verification
Run the minimum required relevant checks:
- smoke,
- unit,
- integration,
- e2e,
- full verification when required.

### Step 7. Update Artifacts
Record:
- changed files,
- implementation summary,
- verification commands,
- verification results,
- blockers,
- clean-state result,
- next step.

### Step 8. Prepare Handoff
Leave the repo in a state that reviewer or next session can use immediately.

---

## 9. Scope Control Rules

A valid implementation session should stay within:

- selected work item,
- selected scope,
- selected verification path,
- selected file cluster.

If the task starts spreading into:
- multiple unrelated flows,
- multiple subsystems,
- broad refactor territory,
- multiple independent acceptance criteria,

stop and recommend task re-breakdown.

Do not silently convert implementation into redesign.

---

## 10. File Change Rules

Prefer changes in expected files first.

Unexpected files may be changed only when:
1. correctness requires it,
2. the change is limited,
3. the change is recorded,
4. the task still remains within bounded scope.

If file spread becomes too broad, escalate to planner/task-breakdown.

---

## 11. Verification Mapping Rules

Use the narrowest meaningful verification that satisfies repository policy.

### Smoke
Always relevant for baseline readiness.

### Unit
Use when the changed logic is locally testable.

### Integration
Use when component/service interaction changed.

### E2E
Use when user-visible or end-to-end workflow changed.

### Full Verification
Use when:
- repository policy requires it,
- shared runtime changed,
- core state changed,
- contracts changed,
- task explicitly requires it.

Do not claim verification success unless commands actually ran.

---

## 12. Artifact Update Rules

### current_task.json
Update:
- actual files changed
- completed steps
- executed verification
- verification result
- review status if applicable
- blocker status
- handoff state

### feature_list.json / backlog.json
Update when task state changes:
- status
- passes
- notes
- blocked reason if relevant

### claude-progress.txt
Append a session block with:
- goal
- changes
- verification
- result
- blockers
- next step

### known_issues.json
Update only when:
- a new issue is discovered,
- an old issue is clarified,
- a blocker needs to be formally recorded.

### session_summary.json
Update at session close.

---

## 13. Completion Rules

A task may be considered implemented only when:

1. selected acceptance criteria are satisfied,
2. changes remain within bounded scope,
3. required verification ran,
4. results are recorded,
5. artifacts are consistent,
6. repository is resumable.

A task may be marked passed only when:
- verification succeeded,
- no blocking issue invalidates completion,
- review requirements are met when policy requires review.

---

## 14. Failure Handling

If implementation cannot complete:

1. record the blocker,
2. preserve any safe progress,
3. avoid pretending the task passed,
4. update artifacts,
5. leave a clear next step.

If verification fails:
- record which command failed,
- record whether the feature is partially implemented,
- record whether recovery is needed,
- keep the repository understandable.

---

## 15. Handoff Template

Use this structure after applying the skill:

### Selected Task
- `{{WORK_ITEM_ID}}`
- `{{WORK_ITEM_TITLE}}`

### What Changed
- {{CHANGE_1}}
- {{CHANGE_2}}
- {{CHANGE_3}}

### Files Changed
- {{ACTUAL_FILE_1}}
- {{ACTUAL_FILE_2}}
- {{ACTUAL_FILE_3}}

### Verification Executed
- {{EXECUTED_VERIFY_1}}
- {{EXECUTED_VERIFY_2}}
- {{EXECUTED_VERIFY_3}}

### Result
- {{IMPLEMENTATION_RESULT}}

### Blockers
- {{BLOCKER_1}}
- {{BLOCKER_2}}

### Next Recommended Step
- {{NEXT_STEP_1}}
- {{NEXT_STEP_2}}

---

## 16. Do Not Rules

- Do not implement outside current task scope.
- Do not skip smoke for normal feature work.
- Do not mark a task passed from intuition.
- Do not leave hidden partial changes without artifact updates.
- Do not broaden the task into large refactor work.
- Do not ignore reviewer-required gates.
- Do not hide verification failures.

---

## 17. Success Definition

This skill succeeds when:

1. one bounded feature task is implemented,
2. required verification is executed,
3. artifact state is updated consistently,
4. repository remains resumable,
5. reviewer or next session can continue without reconstructing context.

---

## 18. Notes

This skill is intended to be reused by:
- coder agent
- bounded implementation sessions
- rework sessions after task rejection
- feature-focused harness loops

It is not a substitute for planning or review.
It is an implementation execution skill.