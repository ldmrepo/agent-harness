# AGENTS.md

## Document Info
- Template Version: {{HARNESS_TEMPLATE_VERSION}}
- Project Name: {{PROJECT_NAME}}
- Repository Name: {{REPOSITORY_NAME}}
- Runtime Type: {{RUNTIME_TYPE}}
- Primary Stack: {{PRIMARY_STACK}}
- Package Manager: {{PACKAGE_MANAGER}}
- Default Branch: {{DEFAULT_BRANCH}}
- Created At: {{CREATED_AT}}
- Updated At: {{UPDATED_AT}}

---

## 1. Purpose

This repository uses a long-running coding-agent harness.

The purpose of this harness is to:
1. maintain progress across multiple sessions,
2. restrict each session to a small verifiable unit of work,
3. ensure design, implementation, review, and verification are repeatable,
4. keep repository state resumable,
5. reduce dependence on model memory by using repository artifacts.

This file defines the mandatory operating rules for agents working in this repository.

---

## 2. Scope

This policy applies to all agent roles in this repository:

- strategist
- planner
- initializer
- coder / generator
- reviewer / evaluator

Optional subagents may be used when enabled by the project.

---

## 3. Required Repository Files

The following files are mandatory and must be treated as operational artifacts:

- `./AGENTS.md`
- `./init.sh`
- `./claude-progress.txt`
- `./feature_list.json`

Optional but recommended artifacts:

- `./tasks/current_task.json`
- `./tasks/backlog.json`
- `./state/session_summary.json`
- `./state/known_issues.json`
- `./state/qa_tuning_log.json`
- `./project_goal.md`
- `./roadmap.json`
- `./state/strategic_review.json`
- `./verification/smoke.sh`
- `./verification/verify_all.sh`

---

## 4. Global Principles

1. One session must focus on exactly one work item unless explicitly allowed otherwise.
2. No work item may be marked complete without verification.
3. Progress must be recorded in repository files, not only in conversation context.
4. The repository must be left in a clean resumable state at session end.
5. Smoke failure blocks new feature work until the existing breakage is resolved.
6. Project-specific execution commands must come from repository configuration variables, not guessed ad hoc.
7. Agents should prefer the smallest safe change that satisfies the selected task.

---

## 5. Project Variables

All project-dependent values must be treated as variables.

### 5.1 Identity Variables
- `{{PROJECT_NAME}}`
- `{{REPOSITORY_NAME}}`
- `{{PROJECT_DESCRIPTION}}`

### 5.2 Runtime Variables
- `{{RUNTIME_TYPE}}`
- `{{PRIMARY_STACK}}`
- `{{PACKAGE_MANAGER}}`
- `{{LANGUAGE_MAIN}}`
- `{{LANGUAGE_SECONDARY}}`

### 5.3 Command Variables
- `{{CMD_INSTALL}}`
- `{{CMD_DEV}}`
- `{{CMD_BUILD}}`
- `{{CMD_LINT}}`
- `{{CMD_TYPECHECK}}`
- `{{CMD_TEST_UNIT}}`
- `{{CMD_TEST_INTEGRATION}}`
- `{{CMD_TEST_E2E}}`
- `{{CMD_DB_MIGRATE}}`

### 5.4 Verification Variables
- `{{HEALTHCHECK_URL}}`
- `{{SMOKE_CHECK_TARGET}}`
- `{{VERIFY_ALL_MODE}}`
- `{{CORE_E2E_TARGET}}`

### 5.5 Environment Variables
- `{{APP_PORT}}`
- `{{API_PORT}}`
- `{{DB_PORT}}`
- `{{CACHE_PORT}}`
- `{{ENV_FILE}}`

### 5.6 Git Variables
- `{{DEFAULT_BRANCH}}`
- `{{COMMIT_PREFIX_FEAT}}`
- `{{COMMIT_PREFIX_FIX}}`
- `{{COMMIT_PREFIX_CHORE}}`

### 5.7 Policy Variables
- `{{ALLOW_PARALLEL_TASKS}}`
- `{{REQUIRE_REVIEW_AGENT}}`
- `{{REQUIRE_FULL_VERIFY_FOR_CORE_CHANGE}}`
- `{{ALLOW_AUTO_COMMIT}}`
- `{{REQUIRE_CONTRACT_REVIEW}}`
- `{{SESSION_MAX_SCOPE}}`
- `{{REVIEWER_ENABLE_RUNTIME_VERIFICATION}}`
- `{{CMD_RUNTIME_VERIFY}}`

---

## 6. Agent Roles

### 6.0 Strategist Agent

Responsibilities:
- read `project_goal.md` and analyze project requirements,
- define milestones in `roadmap.json`,
- decompose milestones into `feature_list.json` entries,
- record strategic decisions in `state/strategic_review.json`,
- advance milestones when current work is complete.

Strategist outputs may update:
- `roadmap.json` (owned)
- `feature_list.json` (new entries only — does not modify existing entries)
- `state/strategic_review.json` (owned)

The strategist does NOT:
- select individual tasks (planner's role),
- implement code (coder's role),
- review work (reviewer's role),
- modify `tasks/current_task.json` (planner's artifact).

Trigger conditions:
- `feature_list.json` has no actionable items AND `project_goal.md` exists → initial planning.
- All current milestone features passed AND next milestone exists → milestone advancement.

### 6.1 Planner Agent
Responsibilities:
- interpret requirements,
- select or refine a work item,
- define minimal completion criteria,
- prepare task scope for the session.

Planner outputs may update:
- `feature_list.json`
- `tasks/current_task.json`
- `tasks/backlog.json`

### 6.2 Initializer Agent
Responsibilities:
- prepare repository bootstrap procedures,
- ensure `init.sh` is valid,
- establish baseline execution instructions,
- prepare initial harness artifacts.

Initializer outputs may update:
- `init.sh`
- `claude-progress.txt`
- `state/environment.json`

### 6.3 Coding / Generator Agent
Responsibilities:
- implement the selected task,
- keep change scope contained,
- run required verification,
- update progress and feature status.

Coding outputs may update:
- application code
- tests
- `feature_list.json`
- `claude-progress.txt`

### 6.4 Review / Evaluator Agent
Responsibilities:
- verify the implementation result,
- validate completion criteria,
- detect regression risk,
- approve or reject completion.

Reviewer outputs may update:
- review notes
- `state/session_summary.json`
- status fields in task artifacts

---

## 7. Session Lifecycle

Every session must follow the same lifecycle.

### 7.1 Session Start Procedure

Execute the following in order:

1. confirm repository root
2. read `claude-progress.txt`
3. read `feature_list.json`
4. inspect recent git history
5. run bootstrap
6. run smoke verification
7. if smoke fails, stop new feature work and fix the failure first

Reference commands:
- repository root check: `pwd`
- git history: `git log --oneline -20`
- bootstrap: `{{CMD_BOOTSTRAP}}`
- smoke verify: `{{CMD_SMOKE}}`

### 7.2 Session Planning Procedure

After successful session start:

1. choose exactly one work item with incomplete status,
2. define scope boundaries,
3. define verification method,
4. define expected output,
5. define rollback risk.
6. if `{{REQUIRE_CONTRACT_REVIEW}} = true`, request reviewer validation of scope, acceptance criteria, and verification plan before implementation begins.

### 7.3 Session Implementation Procedure

During implementation:

1. modify only files relevant to the selected task,
2. avoid unrelated refactoring,
3. keep runtime executable,
4. add or update tests when needed,
5. stop and fix blocking regressions immediately.

### 7.4 Session End Procedure

Before ending the session:

1. run required verification,
2. update work item status,
3. append a progress entry,
4. produce a focused commit if allowed,
5. leave the repository resumable for the next session.

---

## 8. Task Selection Rules

1. Select one task with incomplete status.
2. Prefer the lowest priority number unless project rules say otherwise.
3. Do not silently redefine an existing task.
4. Do not delete task entries without explicit instruction.
5. If a task is too large, split it into smaller tasks before implementation.
6. If `{{ALLOW_PARALLEL_TASKS}} = false`, do not work on multiple tasks in one session.

A task is considered selectable if:
- it is not passed,
- its dependencies are satisfied,
- smoke verification is passing,
- it is within `{{SESSION_MAX_SCOPE}}`.

---

## 9. Verification Policy

Verification is mandatory.

### 9.1 Required Verification Levels

#### Smoke Verification
Use for:
- bootstrap confirmation
- health check
- minimum runtime readiness

Command:
- `{{CMD_SMOKE}}`

#### Feature-Level Verification
Use for:
- selected task behavior validation
- targeted regression checks

Command examples:
- `{{CMD_TEST_UNIT}}`
- `{{CMD_TEST_INTEGRATION}}`
- `{{CMD_TEST_E2E}}`

#### Full Verification
Use when:
- shared runtime changed,
- core state management changed,
- schema or API contract changed,
- `{{REQUIRE_FULL_VERIFY_FOR_CORE_CHANGE}} = true`

Command:
- `{{CMD_VERIFY_ALL}}`

### 9.2 Completion Gate

A task may be marked complete only when:

1. intended behavior is implemented,
2. required verification passed,
3. no obvious regression remains,
4. progress is recorded,
5. reviewer approval exists if `{{REQUIRE_REVIEW_AGENT}} = true`.
6. contract review completed if `{{REQUIRE_CONTRACT_REVIEW}} = true`.

---

## 10. Progress Logging Policy

At the end of every session, append an entry to `claude-progress.txt`.

Each entry must contain:

- timestamp
- session type
- session goal
- selected feature/task id
- files changed
- verification executed
- result
- known issues
- recommended next step

Required timestamp format:
- `{{TIMESTAMP_FORMAT}}`

---

## 11. Feature Status Policy

`feature_list.json` is the source of truth for work-item completion state.

Allowed status fields may include:
- `passes`
- `status`
- `notes`
- `last_verified_at`
- `last_verified_by`

Rules:
1. Do not set completion to true without verification.
2. Do not use progress notes as a substitute for status update.
3. Do not mark partially working behavior as complete.
4. If blocked, record the blocking condition in `notes`.

---

## 12. Git Policy

If `{{ALLOW_AUTO_COMMIT}} = true`, create a focused commit at session end.

Recommended commit formats:
- `{{COMMIT_PREFIX_FEAT}}(F-001): {{COMMIT_MESSAGE_SUMMARY}}`
- `{{COMMIT_PREFIX_FIX}}(F-014): {{COMMIT_MESSAGE_SUMMARY}}`
- `{{COMMIT_PREFIX_CHORE}}(harness): {{COMMIT_MESSAGE_SUMMARY}}`

Git rules:
1. keep commits scoped,
2. do not mix unrelated work,
3. do not commit broken runtime unless explicitly allowed,
4. prefer resumable clean state before commit.

---

## 13. Clean-State Definition

A session is considered clean only if all of the following are true:

1. repository bootstrap is known,
2. selected task changes are saved,
3. required verification completed,
4. progress entry written,
5. next session can resume without reconstructing hidden context.

A clean state does not require the entire backlog to be complete.
A clean state does require the repository to be understandable and resumable.

---

## 14. Failure and Recovery Policy

If smoke verification fails:

1. do not begin new feature work,
2. diagnose the failure,
3. restore minimum runnable state,
4. record the issue,
5. only then continue normal flow.

If a session leaves unstable results:
- update `claude-progress.txt`,
- update `state/known_issues.json` if present,
- avoid marking the task complete.

Rollback helpers may be provided in:
- `./scripts/rollback_last_good.sh`

---

## 15. Reviewer Policy

If a dedicated reviewer exists, the reviewer must independently evaluate:

- intended behavior match
- verification completeness
- regression risk
- completion approval

If no dedicated reviewer exists:
- the coding agent must perform explicit self-review,
- self-review must be recorded,
- completion still requires verification evidence.

### QA Tuning Policy

If `state/qa_tuning_log.json` is present:
1. The reviewer must record `[QA-UNCERTAIN]` and `[QA-RATIONALIZATION-RISK]` flags when applicable.
2. Missed issues discovered in subsequent sessions must be logged.
3. A QA tuning session should be conducted at the interval defined by `{{QA_TUNING_INTERVAL}}`.

---

## 16. Do Not Rules

- Do not skip smoke checks.
- Do not work on multiple unrelated tasks in one session.
- Do not mark a task complete from intuition alone.
- Do not rely on hidden memory for state handoff.
- Do not leave undocumented partial work.
- Do not silently change project variables without recording the reason.

---

## 17. End-of-Session Checklist

- [ ] repository root confirmed
- [ ] progress file read
- [ ] feature list read
- [ ] bootstrap executed
- [ ] smoke verification executed
- [ ] selected exactly one task
- [ ] implementation scoped correctly
- [ ] required verification completed
- [ ] feature/task status updated
- [ ] progress entry appended
- [ ] commit created if allowed
- [ ] repository left resumable

---

## 18. Template Notes

This file is a project-neutral template.
All project-dependent commands, endpoints, ports, policies, and naming conventions must be injected via variables.

No hard-coded project-specific values should remain after project setup.