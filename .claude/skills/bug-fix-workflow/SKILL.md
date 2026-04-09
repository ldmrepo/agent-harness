---
name: bug-fix-workflow
description: >
  Handles bounded bug-fix sessions in the long-running harness by reproducing,
  isolating, fixing, verifying, and recording defects with explicit blocker and issue tracking.
version: {{SKILL_VERSION}}
owner_role: coder
applicability:
  - bugfix
  - regression-fix
  - recovery-fix
  - bounded-debugging-session
  - long-running-agent-harness
tags:
  - bugfix
  - debugging
  - regression
  - verification
  - recovery
---

# Bug Fix Workflow Skill

## 1. Purpose

This skill standardizes how a bounded bug-fix task is executed inside the long-running harness.

Use this skill to make bug-fix work:
- reproducible,
- scoped,
- evidence-based,
- verifiable,
- resumable,
- properly recorded in task and issue artifacts.

This skill exists to prevent:
- vague debugging,
- hidden partial fixes,
- unverified “seems fixed” claims,
- missing issue records,
- regression-prone hotfixes.

---

## 2. When To Use

Use this skill when one or more of the following is true:

1. the selected task type is `bugfix`,
2. a regression must be corrected,
3. a previously implemented task was rejected due to incorrect behavior,
4. smoke or feature-level behavior is broken in a bounded way,
5. a known issue has a clear reproduction path,
6. a small recovery fix is needed before feature work can continue.

Typical examples:
- endpoint returns wrong status
- UI flow breaks after recent change
- duplicate submission bug
- flaky integration behavior with known trigger
- startup failure caused by bounded configuration issue

---

## 3. When Not To Use

Do not use this skill as the primary action when:

1. the repository first needs bootstrap normalization,
2. the issue is too large and should be decomposed first,
3. the problem is architectural redesign rather than bounded bug-fix,
4. no reproduction path or acceptance criteria can be defined,
5. the real next step is planning rather than debugging.

In those cases, use:
- repo-bootstrap,
- task-breakdown,
- or planner-oriented refinement first.

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
- failing tests
- recent git diff
- recent commits
- runtime logs
- previous rejection notes
- reproduction notes from issues

---

## 5. Expected Outputs

This skill should produce or update:

### Required
- bounded code/config/test changes for the fix
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{PROGRESS_FILE_PATH}}`

### When issue state changes
- `{{KNOWN_ISSUES_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`

### At session close
- `{{SESSION_SUMMARY_FILE_PATH}}`

### Optional
- focused recovery/bugfix commit if policy allows

---

## 6. Bug-Fix Principles

### 6.1 Reproduce Before Claiming a Fix
A bug should be tied to a concrete failing condition when possible.

### 6.2 Fix the Cause, Not Only the Symptom
Prefer the smallest fix that resolves the actual defect source.

### 6.3 Keep Scope Bounded
Do not let one bugfix silently expand into broad redesign unless explicitly required.

### 6.4 Verification Must Cover the Failure Path
Verification should prove that the previous failing behavior no longer fails.

### 6.5 Record Defect State Explicitly
Known issue status, workaround, blocker state, and verification outcome must be externalized.

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
- `{{REQUIRE_FULL_VERIFY_FOR_CORE_CHANGE}}`
- `{{REQUIRE_REVIEW_AGENT}}`
- `{{ALLOW_AUTO_COMMIT}}`
- `{{SESSION_MAX_SCOPE}}`

### Commit Conventions
- `{{COMMIT_PREFIX_FIX}}`
- `{{COMMIT_PREFIX_CHORE}}`

---

## 8. Step-by-Step Procedure

### Step 1. Load Bug Context
Read:
- current task
- known issues
- progress log
- last session summary
- relevant reports and logs

Determine:
- exact failing behavior,
- reproduction path,
- affected scope,
- known blocker state,
- expected fixed behavior.

### Step 2. Establish Baseline
Run:
- `{{CMD_BOOTSTRAP}}`
- `{{CMD_SMOKE}}`

If the selected task is not a runtime recovery task and baseline is broken more broadly than the selected issue, record that the bugfix is blocked by broader recovery.

### Step 3. Reproduce the Failure
Prefer one or more of:
- failing smoke path
- failing test
- failing integration
- failing e2e
- deterministic manual reproduction steps

If reproduction is impossible, explicitly record that limitation.

### Step 4. Isolate the Failure Surface
Identify:
- minimal files involved,
- probable defect source,
- regression boundary,
- whether this is local logic, integration, state, or UI issue.

### Step 5. Apply the Smallest Safe Fix
Implement the narrowest correction that addresses the defect.
Avoid bundling unrelated cleanup unless necessary for correctness.

### Step 6. Add or Adjust Regression Coverage
When appropriate, add or update:
- unit tests
- integration tests
- e2e checks
- smoke checks

so that the bug has a repeatable non-regression signal.

### Step 7. Verify the Fix
Run the relevant commands that prove:
- the old failing path no longer fails,
- the runtime still works,
- broader validation ran when required.

### Step 8. Update Artifacts
Update:
- task state
- issue state
- progress log
- session summary
- feature/backlog status when appropriate

### Step 9. Prepare Handoff
Leave:
- what failed before,
- what was changed,
- what verification proves the fix,
- what risks remain,
- what next step is recommended.

---

## 9. Reproduction Rules

A valid bug-fix session should define at least one of:

- deterministic reproduction steps,
- failing automated check,
- failing smoke path,
- failing endpoint/UI path,
- clear log-based failure signature.

If none can be defined, do not pretend the bug is fully understood.
Record the missing reproducibility and limit the claim accordingly.

---

## 10. Scope Control Rules

A bugfix remains valid only while it stays bounded to the selected issue.

If the work expands into:
- multiple unrelated defects,
- broad refactor,
- large design rewrite,
- multiple subsystems,
- policy changes beyond the defect boundary,

stop and recommend decomposition or redesign planning.

Do not hide architectural work inside a bugfix label.

---

## 11. Verification Mapping Rules

Use the narrowest meaningful verification that proves the defect is fixed.

### Smoke
Use when the issue affects:
- startup
- baseline readiness
- minimum runtime availability

### Unit
Use when the defect is isolated logic.

### Integration
Use when the defect is interaction-based.

### E2E
Use when the defect is end-user-visible.

### Full Verification
Use when:
- shared runtime changed,
- broad regression surface exists,
- repository policy requires it,
- the selected issue touches core behavior.

Do not claim a fix without evidence tied to the original failure mode.

---

## 12. Known Issue Update Rules

When the bug corresponds to a known issue, update:

- status
- workaround
- root cause notes
- verification required/completed
- blocker flag if changed
- close conditions if satisfied
- notes and timestamps

If the bug revealed a new defect, add a new issue entry rather than hiding it inside general notes.

---

## 13. Artifact Update Rules

### current_task.json
Update:
- implementation notes
- actual files changed
- verification executed
- verification result
- blocked state
- handoff notes

### known_issues.json
Update:
- issue status
- reproduction notes
- workaround
- verification result
- close state when appropriate

### feature_list.json / backlog.json
Update when task state or pass state changes.

### claude-progress.txt
Append:
- defect addressed
- fix summary
- verification evidence
- residual risk
- next step

### session_summary.json
Update at session close.

---

## 14. Completion Rules

A bugfix may be considered complete only when:

1. the defect is tied to a concrete failure path,
2. the selected issue was addressed within bounded scope,
3. relevant verification ran,
4. verification evidence supports the fix,
5. issue/task artifacts are updated,
6. repository is resumable.

A bugfix may be marked passed only when:
- the failure no longer reproduces under the defined check,
- required verification passed,
- no blocking regression invalidates the fix,
- review requirements are satisfied if required.

---

## 15. Failure Handling

If the defect is not fully fixed:

1. do not claim closure,
2. record what was learned,
3. record the remaining failure mode,
4. record whether partial mitigation exists,
5. record the next best step.

If the issue is broader than expected:
- mark the current task as blocked or partial,
- recommend decomposition or planning,
- update known issues accordingly.

---

## 16. Handoff Template

Use this structure after applying the skill:

### Bug / Task
- `{{WORK_ITEM_ID}}`
- `{{WORK_ITEM_TITLE}}`

### Previous Failure
- {{PREVIOUS_FAILURE_1}}
- {{PREVIOUS_FAILURE_2}}

### What Changed
- {{CHANGE_1}}
- {{CHANGE_2}}
- {{CHANGE_3}}

### Verification Executed
- {{EXECUTED_VERIFY_1}}
- {{EXECUTED_VERIFY_2}}
- {{EXECUTED_VERIFY_3}}

### Fix Result
- {{FIX_RESULT}}

### Remaining Risks
- {{RISK_1}}
- {{RISK_2}}

### Next Recommended Step
- {{NEXT_STEP_1}}
- {{NEXT_STEP_2}}

---

## 17. Do Not Rules

- Do not say “fixed” without reproducing or otherwise evidencing the original defect path.
- Do not expand one bugfix into unrelated system changes.
- Do not hide residual failures.
- Do not close known issues without required evidence.
- Do not ignore regression risk.
- Do not leave issue/task artifacts inconsistent.
- Do not mask broader recovery needs with a narrow bugfix claim.

---

## 18. Success Definition

This skill succeeds when:

1. a bounded defect is addressed,
2. the failure path is checked,
3. the fix is verified,
4. issue and task artifacts are updated,
5. repository remains resumable,
6. the next debugging or review step is obvious.

---

## 19. Notes

This skill is intended to be reused by:
- coder agent
- regression-fix sessions
- rejection rework cycles
- smoke-recovery-aligned bugfix loops

It is not a substitute for initialization or planning.
It is a bounded debugging and fix execution skill.