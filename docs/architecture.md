# {{PROJECT_NAME}} Architecture

## Document Info
- Template Version: {{HARNESS_TEMPLATE_VERSION}}
- Document Version: {{ARCHITECTURE_DOC_VERSION}}
- Repository Name: {{REPOSITORY_NAME}}
- Runtime Type: {{RUNTIME_TYPE}}
- Primary Stack: {{PRIMARY_STACK}}
- Created At: {{CREATED_AT}}
- Updated At: {{UPDATED_AT}}

---

## 1. Purpose

This document describes the fixed harness-aligned architecture for `{{PROJECT_NAME}}`.

Its purpose is to define:

- the overall system shape,
- the harness operating layers,
- agent role boundaries,
- state artifact structure,
- verification layers,
- recovery and handoff model,
- project-specific runtime placeholders as variables.

> **Note:** The authoritative specification for this harness is the Korean standard document
> [`long_running_agent_harness.md`](../long_running_agent_harness.md). This English architecture
> document is the template-level implementation of that specification. The complete variable
> reference is available in [`long_running_agent_harness_variable_dictionary.md`](../long_running_agent_harness_variable_dictionary.md).

This document is repository-oriented and must remain aligned with the fixed folder and file structure.

---

## 2. Architecture Goals

The architecture is designed to ensure that the repository is:

1. resumable across sessions,
2. operable by long-running coding agents,
3. structured around bounded work units,
4. verifiable with explicit gates,
5. recoverable when regressions or runtime failures occur,
6. extensible from single-agent execution to multi-agent orchestration.

---

## 3. Top-Level Architecture

The architecture is divided into the following top-level layers:

1. **Repository Policy Layer**
2. **Bootstrap Layer**
3. **Planning Layer**
4. **Implementation Layer**
5. **Review Layer**
6. **Verification Layer**
7. **State Handoff Layer**
8. **Recovery Layer**
9. **Skills Layer**
10. **Project Runtime Layer**

---

## 4. Layer Descriptions

### 4.1 Repository Policy Layer
Primary artifacts:
- `{{AGENTS_FILE_PATH}}`
- `.claude/agents/*`
- `.claude/skills/*`

Responsibilities:
- define operating rules,
- define role behavior,
- define review and verification policy,
- define session structure,
- constrain scope and completion conditions.

### 4.2 Bootstrap Layer
Primary artifacts:
- `{{INIT_SCRIPT_PATH}}`
- `scripts/bootstrap_env.sh`
- `state/environment.json`

Responsibilities:
- normalize environment,
- install dependencies,
- start runtime processes,
- start infra if required,
- establish health baseline.

### 4.3 Planning Layer
Primary artifacts:
- `.claude/agents/planner.md`
- `.claude/skills/task-breakdown/SKILL.md`
- `tasks/backlog.json`
- `tasks/current_task.json`
- `feature_list.json`

Responsibilities:
- choose the next bounded task,
- decompose oversized tasks,
- define scope and acceptance criteria,
- define verification plan,
- prepare handoff to coder.

### 4.4 Implementation Layer
Primary artifacts:
- `.claude/agents/coder.md`
- `.claude/skills/feature-implementation/SKILL.md`
- `.claude/skills/bug-fix-workflow/SKILL.md`

Responsibilities:
- implement the selected work item,
- keep changes within scope,
- run required verification,
- update state artifacts,
- maintain clean-state handoff.

### 4.5 Review Layer
Primary artifacts:
- `.claude/agents/reviewer.md`
- `.claude/skills/code-review-checklist/SKILL.md`
- `.claude/skills/regression-check/SKILL.md`
- `.claude/skills/test-gate/SKILL.md`

Responsibilities:
- review scope compliance,
- assess correctness,
- validate verification evidence,
- assess regression risk,
- determine approval/rejection/pending.

### 4.6 Verification Layer
Primary artifacts:
- `verification/smoke.sh`
- `verification/verify_all.sh`
- `verification/unit/*`
- `verification/integration/*`
- `verification/e2e/*`

Responsibilities:
- enforce smoke readiness,
- enforce task-level validation,
- enforce full verification when required,
- provide machine-readable reports,
- support approval and recovery decisions.

### 4.7 State Handoff Layer
Primary artifacts:
- `claude-progress.txt`
- `state/session_summary.json`
- `state/known_issues.json`
- `tasks/current_task.json`
- `feature_list.json`

Responsibilities:
- carry state across sessions,
- externalize progress,
- record blockers and risks,
- record verification outcomes,
- reduce dependence on hidden memory.

### 4.8 Recovery Layer
Primary artifacts:
- `scripts/collect_status.sh`
- `scripts/rollback_last_good.sh`

Responsibilities:
- inspect repository/runtime state,
- detect unhealthy baseline,
- restore known-good state,
- collect post-recovery status,
- re-establish smoke readiness.

### 4.9 Skills Layer
Primary artifacts:
- `.claude/skills/repo-bootstrap/SKILL.md`
- `.claude/skills/task-breakdown/SKILL.md`
- `.claude/skills/feature-implementation/SKILL.md`
- `.claude/skills/bug-fix-workflow/SKILL.md`
- `.claude/skills/code-review-checklist/SKILL.md`
- `.claude/skills/regression-check/SKILL.md`
- `.claude/skills/test-gate/SKILL.md`

Responsibilities:
- provide reusable procedures,
- standardize execution quality,
- reduce repetition in role prompts,
- support specialization by role.

### 4.10 Project Runtime Layer
Primary artifacts:
- `{{APP_DIR_NAME}}/*`
- `{{DOCS_DIR_NAME}}/*`
- `{{TASKS_DIR_NAME}}/*`
- runtime/config/test files specific to the project

Responsibilities:
- hold actual product/application code,
- expose runtime entry points,
- expose test surfaces,
- expose integration boundaries,
- serve as the object manipulated by the harness.

---

## 5. Role Architecture

The system supports these core roles:

### 5.1 Planner
Purpose:
- selects one bounded next task,
- enforces session size,
- defines acceptance/verification path.

Primary inputs:
- backlog
- feature list
- current task
- progress
- known issues

Primary outputs:
- selected current task
- updated planning artifacts

### 5.2 Initializer
Purpose:
- normalizes bootstrap and baseline artifacts,
- prepares repository for long-running sessions.

Primary inputs:
- repository scripts
- manifests
- environment conventions

Primary outputs:
- init path
- state artifacts
- baseline verification entry points

### 5.3 Coder
Purpose:
- implements the selected bounded task,
- updates repository and state.

Primary inputs:
- current task
- progress
- environment
- known issues

Primary outputs:
- code changes
- verification results
- progress updates
- session summary

### 5.4 Reviewer
Purpose:
- validates whether session output should be accepted.

Primary inputs:
- current task
- session summary
- verification reports
- known issues
- git diff

Primary outputs:
- review decision
- review notes
- approval impact
- issue escalation if needed

---

## 6. Session Architecture

A session is a closed bounded cycle.

### 6.1 Session Stages
1. **Session Start**
2. **Scope Confirmation**
3. **Implementation or Review Work**
4. **Verification**
5. **Artifact Update**
6. **Handoff / Commit / Recovery Decision**

### 6.2 Session Inputs
- `{{PROGRESS_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{KNOWN_ISSUES_FILE_PATH}}`
- `{{ENVIRONMENT_FILE_PATH}}`

### 6.3 Session Outputs
- code/config/test changes
- verification reports
- progress entry
- session summary
- task state updates
- optional commit

---

## 7. State Architecture

State is externalized into repository artifacts.

### 7.1 Persistent State Files
- `claude-progress.txt`
- `tasks/current_task.json`
- `tasks/backlog.json`
- `feature_list.json`
- `state/session_summary.json`
- `state/known_issues.json`
- `state/environment.json`

### 7.2 State Principles
- no hidden agent-only state should be required,
- next session should resume from files,
- progress and blockers must be explicit,
- verification and review must be reconstructable.

---

## 8. Verification Architecture

Verification is layered.

### 8.1 Smoke Layer
Purpose:
- determine minimum runnable baseline.

Primary artifact:
- `verification/smoke.sh`

### 8.2 Task-Level Verification Layer
Purpose:
- verify the selected task using the narrowest relevant checks.

Typical commands:
- `{{CMD_TEST_UNIT}}`
- `{{CMD_TEST_INTEGRATION}}`
- `{{CMD_TEST_E2E}}`

### 8.3 Full Verification Layer
Purpose:
- verify broader repository integrity when required.

Primary artifact:
- `verification/verify_all.sh`

### 8.4 Review/Approval Gate Layer
Purpose:
- decide whether verification evidence is sufficient for approval.

Primary artifacts:
- reviewer agent
- review/test-gate/regression-check skills

---

## 9. Recovery Architecture

Recovery is a first-class path, not an exception.

### 9.1 Recovery Triggers
- smoke failure
- blocked runtime
- broken clean state
- failed regression gate
- known critical issue
- broken rollback-sensitive change

### 9.2 Recovery Tools
- `scripts/collect_status.sh`
- `scripts/rollback_last_good.sh`

### 9.3 Recovery Outcome
A recovery pass should result in one of:
- resumed healthy baseline
- blocked but understood state
- rollback to known-good commit
- recovery follow-up task creation

---

## 10. Harness Evolution Architecture

### 10.1 Purpose
Track and reassess the model-limitation assumptions encoded in each harness component.

### 10.2 Primary Artifact
- `docs/harness_assumptions.md`

### 10.3 Responsibilities
- document why each harness component exists,
- define stress tests for each assumption,
- trigger periodic reassessment when models change,
- enable informed simplification as models improve.

### 10.4 Evolution Principle
A harness component that no longer catches real issues is overhead, not safety. Remove it.

---

## 11. Artifact Flow

### 10.1 Planning Flow
`tasks/backlog.json`
→ task breakdown / selection
→ `tasks/current_task.json`
→ `feature_list.json`

### 10.2 Execution Flow
`tasks/current_task.json`
→ implementation
→ verification
→ `claude-progress.txt`
→ `state/session_summary.json`

### 10.3 Review Flow
`state/session_summary.json`
+ verification reports
+ current task
→ reviewer decision
→ task / feature / issue updates

### 10.4 Recovery Flow
status collection
→ issue detection
→ rollback or repair
→ smoke re-check
→ state updates

---

## 12. Fixed Folder Structure

```text id="64208"
{{REPOSITORY_NAME}}/
├─ AGENTS.md
├─ init.sh
├─ claude-progress.txt
├─ feature_list.json
├─ tasks/
│  ├─ current_task.json
│  ├─ backlog.json
│  └─ done/
├─ verification/
│  ├─ smoke.sh
│  ├─ verify_all.sh
│  ├─ e2e/
│  ├─ unit/
│  └─ integration/
├─ scripts/
│  ├─ bootstrap_env.sh
│  ├─ collect_status.sh
│  ├─ commit_session.sh
│  └─ rollback_last_good.sh
├─ state/
│  ├─ session_summary.json
│  ├─ known_issues.json
│  ├─ environment.json
│  └─ checkpoints/
├─ .claude/
│  ├─ agents/
│  └─ skills/
├─ docs/
│  ├─ architecture.md
│  ├─ runbook.md
│  └─ quality_gates.md
└─ {{APP_DIR_NAME}}/