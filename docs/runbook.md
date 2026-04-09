# {{PROJECT_NAME}} Runbook

## Document Info
- Template Version: {{HARNESS_TEMPLATE_VERSION}}
- Document Version: {{RUNBOOK_DOC_VERSION}}
- Repository Name: {{REPOSITORY_NAME}}
- Runtime Type: {{RUNTIME_TYPE}}
- Primary Stack: {{PRIMARY_STACK}}
- Created At: {{CREATED_AT}}
- Updated At: {{UPDATED_AT}}

---

## 1. Purpose

This runbook defines how to operate `{{PROJECT_NAME}}` within the fixed long-running agent harness structure.

Its purpose is to provide clear operational procedures for:

- starting a session,
- bootstrapping the repository,
- selecting work,
- implementing and verifying work,
- reviewing and approving work,
- handling failures and recovery,
- updating state artifacts,
- ending sessions safely.

This document is operational rather than architectural.
It should be used as the step-by-step guide for repository execution.

---

## 2. Operating Principles

1. every session must start from repository artifacts,
2. every session must have one bounded primary purpose,
3. verification is part of execution, not optional afterthought,
4. state must be externalized in files,
5. recovery is an explicit supported flow,
6. session end requires a resumable repository state.

---

## 3. Core Artifacts

The following repository artifacts are operationally critical:

### Required
- `{{AGENTS_FILE_PATH}}`
- `{{INIT_SCRIPT_PATH}}`
- `{{PROGRESS_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`
- `{{KNOWN_ISSUES_FILE_PATH}}`
- `{{SESSION_SUMMARY_FILE_PATH}}`
- `{{ENVIRONMENT_FILE_PATH}}`

### Verification
- `{{SMOKE_SCRIPT_PATH}}`
- `{{VERIFY_ALL_SCRIPT_PATH}}`
- `{{SMOKE_REPORT_FILE_PATH}}`
- `{{VERIFY_ALL_REPORT_FILE_PATH}}`

### Recovery / Helper Scripts
- `scripts/bootstrap_env.sh`
- `scripts/collect_status.sh`
- `scripts/commit_session.sh`
- `scripts/rollback_last_good.sh`

---

## 4. Session Types

Supported session types:

### 4.1 Planner Session
Purpose:
- select the next bounded task,
- refine backlog,
- define scope and verification.

Primary agent:
- planner

Primary outputs:
- updated `tasks/current_task.json`
- updated planning artifacts

### 4.2 Initializer Session
Purpose:
- normalize bootstrap and environment,
- ensure required artifacts exist,
- prepare baseline runtime readiness.

Primary agent:
- initializer

Primary outputs:
- updated bootstrap/verification/state artifacts

### 4.3 Coding Session
Purpose:
- implement the selected bounded task,
- run required verification,
- update artifacts.

Primary agent:
- coder

Primary outputs:
- code/test/config changes
- updated task/progress/session summary

### 4.4 Reviewer Session
Purpose:
- evaluate correctness, scope compliance, verification evidence, and regression risk.

Primary agent:
- reviewer

Primary outputs:
- review decision
- updated review/task/session artifacts

### 4.5 Recovery Session
Purpose:
- restore a healthy baseline,
- rollback or repair,
- re-establish smoke readiness.

Primary agent:
- coder or reviewer in recovery mode

Primary outputs:
- restored state or explicit blocked state

---

## 5. Standard Session Start Procedure

Use this sequence at the start of most sessions.

### Step 1. Confirm Repository Root
Check that you are operating in the intended repository root.

Recommended command:
- `pwd`

### Step 2. Read Core State Files
Read:
- `{{PROGRESS_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{KNOWN_ISSUES_FILE_PATH}}`
- `{{ENVIRONMENT_FILE_PATH}}`

### Step 3. Inspect Recent Git History
Recommended command:
- `git log --oneline -20`

### Step 4. Bootstrap the Environment
Recommended command:
- `{{CMD_BOOTSTRAP}}`

### Step 5. Run Smoke Verification
Recommended command:
- `{{CMD_SMOKE}}`

### Step 6. Decide Normal Flow vs Recovery Flow
If smoke fails:
- do not start normal feature work,
- assess whether recovery is the true next action.

---

## 6. Planner Session Procedure

Use this when the next task must be selected or refined.

### Step 1. Read Backlog and Current State
Read:
- `{{BACKLOG_FILE_PATH}}`
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{KNOWN_ISSUES_FILE_PATH}}`
- recent progress/session summaries

### Step 2. Determine Best Next Task
Prefer:
- unblocked work,
- satisfied dependencies,
- smallest meaningful scope,
- clear verification,
- highest value within bounded session size.

### Step 3. Split Oversized Work If Needed
If a task exceeds `{{SESSION_MAX_SCOPE}}`, apply task breakdown before selection.

### Step 4. Write Current Task
Update:
- `{{CURRENT_TASK_FILE_PATH}}`

Include:
- task identity,
- scope,
- out-of-scope,
- expected files,
- acceptance criteria,
- verification plan.

### Step 5. Update Planning Artifacts
If necessary, update:
- `{{BACKLOG_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`

---

## 7. Initializer Session Procedure

Use this when repository setup or baseline normalization is needed.

### Step 1. Inspect Existing Execution Reality
Inspect:
- manifests
- scripts
- runtime commands
- existing environment and verification setup

### Step 2. Normalize Bootstrap Path
Update or create:
- `{{INIT_SCRIPT_PATH}}`
- `scripts/bootstrap_env.sh`

### Step 3. Normalize Verification Entry Points
Update or create:
- `{{SMOKE_SCRIPT_PATH}}`
- `{{VERIFY_ALL_SCRIPT_PATH}}`

### Step 4. Ensure Required State Artifacts Exist
Ensure:
- `{{PROGRESS_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`
- `{{KNOWN_ISSUES_FILE_PATH}}`
- `{{SESSION_SUMMARY_FILE_PATH}}`
- `{{ENVIRONMENT_FILE_PATH}}`

### Step 5. Validate Baseline
Run:
- `{{CMD_BOOTSTRAP}}`
- `{{CMD_SMOKE}}`

### Step 6. Record Known Gaps
If initialization is incomplete, record explicit issues and next steps.

---

## 8. Coding Session Procedure

Use this when the selected task is ready for implementation.

### Step 1. Read Current Task
Read:
- `{{CURRENT_TASK_FILE_PATH}}`

Confirm:
- selected task id
- scope
- out-of-scope
- expected files
- verification path

### Step 2. Reconfirm Runtime Baseline
Run:
- `{{CMD_BOOTSTRAP}}`
- `{{CMD_SMOKE}}`

### Step 3. Implement the Task
Make the smallest safe change required for the selected work item.

### Step 4. Keep Scope Bounded
If implementation begins spreading:
- stop,
- record the expansion,
- return to planner/task-breakdown if needed.

### Step 5. Run Required Verification
Examples:
- `{{CMD_TEST_UNIT}}`
- `{{CMD_TEST_INTEGRATION}}`
- `{{CMD_TEST_E2E}}`
- `{{CMD_VERIFY_ALL}}` when required

### Step 6. Update Artifacts
Update:
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{PROGRESS_FILE_PATH}}`
- `{{SESSION_SUMMARY_FILE_PATH}}`

Update also when needed:
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`
- `{{KNOWN_ISSUES_FILE_PATH}}`

### Step 7. Optional Commit
If policy allows:
- use `scripts/commit_session.sh`

---

## 9. Reviewer Session Procedure

Use this when implementation claims completion or is ready for approval decision.

### Step 1. Read Review Context
Read:
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{SESSION_SUMMARY_FILE_PATH}}`
- `{{PROGRESS_FILE_PATH}}`
- `{{KNOWN_ISSUES_FILE_PATH}}`
- verification reports

### Step 2. Confirm Scope Compliance
Check:
- selected task alignment
- out-of-scope respect
- expected vs actual file spread

### Step 3. Confirm Verification Evidence
Check:
- executed commands
- pass/fail/skip status
- whether required gate depth was met

### Step 4. Assess Regression Risk
Use:
- regression findings
- changed surface
- shared/runtime impact
- known issue history

### Step 5. Decide Outcome
Set:
- approved
- rejected
- pending
- not_required

### Step 6. Write Review Notes
Update:
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{SESSION_SUMMARY_FILE_PATH}}`

Update also when needed:
- `{{KNOWN_ISSUES_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`

---

## 10. Recovery Session Procedure

Use this when baseline health or repository state is broken.

### Step 1. Collect Status
Recommended command:
- `{{CMD_COLLECT_STATUS}}`

### Step 2. Determine Recovery Strategy
Choose one:
- minimal repair
- rollback to known-good commit
- explicit blocked state with known issue creation

### Step 3. Apply Recovery
Possible command:
- `scripts/rollback_last_good.sh {{ROLLBACK_TARGET_COMMIT}} "{{ROLLBACK_REASON}}"`

### Step 4. Re-run Smoke
Recommended command:
- `{{CMD_SMOKE}}`

### Step 5. Update State
Update:
- `{{KNOWN_ISSUES_FILE_PATH}}`
- `{{SESSION_SUMMARY_FILE_PATH}}`
- `{{PROGRESS_FILE_PATH}}`

Do not resume normal feature work until baseline is healthy enough.

---

## 11. Verification Runbook

### 11.1 Smoke Verification
Purpose:
- confirm minimum runnable state

Recommended command:
- `{{CMD_SMOKE}}`

Expected outcome:
- pass or fail baseline readiness

### 11.2 Task-Level Verification
Purpose:
- validate the selected bounded task

Possible commands:
- `{{CMD_TEST_UNIT}}`
- `{{CMD_TEST_INTEGRATION}}`
- `{{CMD_TEST_E2E}}`

Use the narrowest meaningful checks.

### 11.3 Full Verification
Purpose:
- validate wider repository integrity

Recommended command:
- `{{CMD_VERIFY_ALL}}`

Use when:
- shared/core runtime changed,
- repository policy requires it,
- task explicitly requires it.

---

## 12. Artifact Update Runbook

### 12.1 Progress Log
File:
- `{{PROGRESS_FILE_PATH}}`

Update when:
- a session ends,
- a blocker is discovered,
- a meaningful step is completed.

### 12.2 Current Task
File:
- `{{CURRENT_TASK_FILE_PATH}}`

Update when:
- selected task changes,
- implementation changes,
- verification result changes,
- review result changes.

### 12.3 Feature List / Backlog
Files:
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`

Update when:
- task lifecycle state changes,
- task decomposition occurs,
- new follow-up work is created.

### 12.4 Known Issues
File:
- `{{KNOWN_ISSUES_FILE_PATH}}`

Update when:
- new defects are found,
- regression risk becomes concrete,
- blockers need persistent tracking,
- an issue is verified closed.

### 12.5 Session Summary
File:
- `{{SESSION_SUMMARY_FILE_PATH}}`

Update when:
- a session finishes,
- a review decision is made,
- recovery status must be recorded.

---

## 13. Commit Runbook

### Preconditions
- `{{ALLOW_AUTO_COMMIT}} = true`
- repository policy allows commit
- staged changes exist
- clean-state requirement is satisfied if enabled

### Recommended Command
- `scripts/commit_session.sh`

### Expected Outcome
- focused commit for the selected task
- updated commit state log
- commit message aligned with task type and policy

Do not force a commit if repository state is misleading or broken.

---

## 14. Recovery / Rollback Runbook

### When To Roll Back
- current state is worse than last known-good state,
- repair is slower/riskier than rollback,
- smoke cannot be restored quickly,
- regression is severe and bounded to recent change.

### Recommended Command
- `scripts/rollback_last_good.sh {{ROLLBACK_TARGET_COMMIT}} "{{ROLLBACK_REASON}}"`

### After Rollback
- rerun smoke,
- collect status,
- update known issues and session summary,
- create follow-up task if needed.

---

## 15. Decision Matrix

### If Smoke Fails at Session Start
Action:
- switch to recovery or blocker analysis
Do Not:
- continue normal feature implementation

### If Current Task Is Too Large
Action:
- return to planning and task breakdown
Do Not:
- force implementation of oversized work

### If Verification Fails
Action:
- record failure, keep bounded scope, decide repair or blocked state
Do Not:
- mark task passed

### If Review Finds Scope Drift
Action:
- reject or split into follow-up tasks
Do Not:
- silently approve

### If Regression Risk Is High
Action:
- require more evidence, pending, or reject
Do Not:
- treat local task success as sufficient

---

## 16. Operational Checklists

### Session Start Checklist
- [ ] repository root confirmed
- [ ] progress read
- [ ] current task read
- [ ] known issues read
- [ ] bootstrap run
- [ ] smoke run
- [ ] normal flow vs recovery decided

### Coding Session End Checklist
- [ ] scoped work completed or explicitly blocked
- [ ] verification executed
- [ ] current task updated
- [ ] progress log updated
- [ ] session summary updated
- [ ] known issues updated if needed
- [ ] commit considered or executed
- [ ] repository resumable

### Reviewer Checklist
- [ ] scope checked
- [ ] correctness assessed
- [ ] verification evidence checked
- [ ] artifact consistency checked
- [ ] regression risk checked
- [ ] approval impact recorded

### Recovery Checklist
- [ ] status collected
- [ ] rollback/repair strategy chosen
- [ ] smoke rerun
- [ ] issues recorded
- [ ] next safe step recorded

---

## 17. Variable Injection Model

All project-specific values must be supplied via variables such as:

### Identity
- `{{PROJECT_NAME}}`
- `{{REPOSITORY_NAME}}`

### Runtime
- `{{RUNTIME_TYPE}}`
- `{{PRIMARY_STACK}}`

### Commands
- `{{CMD_BOOTSTRAP}}`
- `{{CMD_SMOKE}}`
- `{{CMD_VERIFY_ALL}}`
- `{{CMD_TEST_UNIT}}`
- `{{CMD_TEST_INTEGRATION}}`
- `{{CMD_TEST_E2E}}`
- `{{CMD_COLLECT_STATUS}}`

### Policy
- `{{SESSION_MAX_SCOPE}}`
- `{{ALLOW_AUTO_COMMIT}}`

### Paths
- `{{PROGRESS_FILE_PATH}}`
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{SESSION_SUMMARY_FILE_PATH}}`
- `{{KNOWN_ISSUES_FILE_PATH}}`

No hard-coded project-specific operational assumptions should remain in this template.

---

## 18. Success Criteria

The runbook is successful when:

1. sessions can be started consistently,
2. bounded work can be executed and verified consistently,
3. review and recovery flows are explicit,
4. artifact updates are repeatable,
5. repository operations remain aligned with the fixed harness structure.

---

## 19. Notes

This document should remain aligned with:
- `docs/architecture.md`
- `AGENTS.md`
- `.claude/agents/*`
- `.claude/skills/*`
- `scripts/*`
- `tasks/*`
- `state/*`
- `verification/*`

When repository policy changes, update this runbook before expecting later sessions to follow the new behavior.

---

## Harness Audit Session

### Purpose
Reassess harness assumptions after model upgrades or at scheduled intervals.

### Procedure
1. Read `docs/harness_assumptions.md`.
2. For each assumption, review evidence from recent sessions.
3. Run stress tests if evidence is ambiguous.
4. Update assumption status (`active`, `weakening`, `retired`).
5. If assumptions are retired, propose harness simplifications.
6. Append audit record to `docs/harness_assumptions.md`.
7. Update `claude-progress.txt` with audit results.

---

## QA Tuning Session

### Purpose
Review accumulated QA performance data and improve reviewer effectiveness.

### When to Run
- After every `{{QA_TUNING_INTERVAL}}` review sessions (recommended: 10)
- When `missed_issues` count exceeds `{{QA_MISSED_THRESHOLD}}` (recommended: 3)
- After adopting a new model version for the reviewer role

### Procedure
1. Read `state/qa_tuning_log.json`.
2. Analyze `missed_issues` for patterns:
   - Which categories recur? (scope violations, missed regressions, etc.)
   - Which phases of review are weakest?
   - Are there common `why_missed` themes?
3. Analyze `false_rejections` for over-strictness:
   - Are certain criteria causing unnecessary blocks?
   - Should any thresholds be relaxed?
4. Draft specific prompt changes for `.claude/agents/reviewer.md`:
   - New Do Not Rules for recurring misses
   - Relaxed criteria for recurring false rejections
   - New check steps for uncovered areas
5. Apply prompt changes.
6. Record the tuning session in `state/qa_tuning_log.json` under `tuning_history`.
7. Update `reviewer_prompt_version` in the summary.
8. Append session entry to `claude-progress.txt`.

### Success Criteria
- All recurring miss patterns have corresponding prompt mitigations.
- False rejection rate is understood and addressed.
- Tuning history is recorded for future reference.