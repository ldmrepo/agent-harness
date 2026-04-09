# {{PROJECT_NAME}} Quality Gates

## Document Info
- Template Version: {{HARNESS_TEMPLATE_VERSION}}
- Document Version: {{QUALITY_GATES_DOC_VERSION}}
- Repository Name: {{REPOSITORY_NAME}}
- Runtime Type: {{RUNTIME_TYPE}}
- Primary Stack: {{PRIMARY_STACK}}
- Created At: {{CREATED_AT}}
- Updated At: {{UPDATED_AT}}

---

## 1. Purpose

This document defines the **quality gate model** for `{{PROJECT_NAME}}` within the fixed long-running agent harness structure.

Its purpose is to make explicit:

- what must be true before work begins,
- what must be true before a task is considered implemented,
- what must be true before a task is considered verified,
- what must be true before a task is approved or passed,
- what conditions force recovery, rejection, or pending states.

This document is the policy reference for:
- planner,
- initializer,
- coder,
- reviewer,
- verification scripts,
- session-close decisions.

---

## 2. Quality Gate Principles

1. **No hidden gates**: every gate condition must be explicit.
2. **Evidence over intent**: planned work does not satisfy a gate; executed evidence does.
3. **Narrowest sufficient verification**: use the smallest meaningful gate that safely covers the change.
4. **Baseline first**: no normal feature work on top of a broken baseline.
5. **Artifact consistency matters**: gate outcomes must be reflected consistently across repository state files.
6. **Recovery is a valid outcome**: failed gates must redirect to recovery or follow-up, not ambiguous progress claims.

---

## 3. Gate Model Overview

The harness uses the following gate sequence:

1. **Repository Readiness Gate**
2. **Task Selection Gate**
3. **Implementation Scope Gate**
4. **Verification Gate**
5. **Regression Gate**
6. **Review Gate**
7. **Pass / Completion Gate**
8. **Recovery Gate**

Not every session uses every gate equally, but all approved task flows must satisfy the relevant ones.

---

## 4. Gate 1 — Repository Readiness Gate

## 4.1 Purpose
This gate determines whether the repository is healthy enough to begin a normal session.

## 4.2 Required Conditions
The repository readiness gate is satisfied when:

- `{{AGENTS_FILE_PATH}}` exists
- `{{ENVIRONMENT_FILE_PATH}}` exists
- `{{PROGRESS_FILE_PATH}}` exists
- `{{FEATURE_LIST_FILE_PATH}}` exists
- `{{CURRENT_TASK_FILE_PATH}}` exists or valid placeholder exists
- `{{BACKLOG_FILE_PATH}}` exists
- `{{KNOWN_ISSUES_FILE_PATH}}` exists
- bootstrap path is known
- smoke path is known

## 4.3 Primary Checks
- `{{CMD_BOOTSTRAP}}`
- `{{CMD_SMOKE}}`

## 4.4 Gate Outcomes
- **passed**: normal session may continue
- **failed**: recovery or initialization required
- **pending**: missing artifact or ambiguous environment must be resolved first

## 4.5 Blocking Rule
If repository readiness gate fails, normal feature implementation must not begin.

---

## 5. Gate 2 — Task Selection Gate

## 5.1 Purpose
This gate determines whether a task is valid for the next session.

## 5.2 Required Conditions
A task is selectable only when:

- it exists in `{{BACKLOG_FILE_PATH}}` or `{{FEATURE_LIST_FILE_PATH}}`
- it is not already `passed`
- dependencies are satisfied
- it is bounded by `{{SESSION_MAX_SCOPE}}`
- verification path is defined
- no higher-priority blocking recovery work takes precedence
- If `{{REQUIRE_CONTRACT_REVIEW}} = true`, the task must have `contract_status = approved` before proceeding to implementation.

## 5.3 Required Task Attributes
A valid selected task must include:

- task id
- title
- description
- priority
- status
- verification type
- acceptance criteria
- expected scope
- out-of-scope definition
- dependency information

## 5.4 Gate Outcomes
- **passed**: task may become current task
- **failed**: task must be rejected, decomposed, or blocked
- **pending**: missing task details must be completed first

---

## 6. Gate 3 — Implementation Scope Gate

## 6.1 Purpose
This gate determines whether actual implementation stayed within the selected task boundary.

## 6.2 Required Conditions
The implementation scope gate is satisfied when:

- actual work matches selected work item
- actual changes remain within approved scope
- out-of-scope boundaries are respected
- unexpected file changes are justified and limited
- work does not silently turn into a larger redesign

## 6.3 Evidence Sources
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{SESSION_SUMMARY_FILE_PATH}}`
- git diff
- changed file list
- progress log
- reviewer findings

## 6.4 Gate Outcomes
- **passed**: work may proceed to verification and review
- **failed**: rejection or task re-breakdown required
- **pending**: further clarification needed before approval

---

## 7. Gate 4 — Verification Gate

## 7.1 Purpose
This gate determines whether the executed verification evidence is sufficient for the task.

## 7.2 Verification Levels
The harness recognizes the following verification levels:

- **smoke**
- **unit**
- **integration**
- **e2e**
- **verify_all**
- **custom gate checks**

## 7.3 Required Conditions
The verification gate is satisfied only when:

- required checks were actually executed
- results are recorded
- pass/fail/skip states are explicit
- chosen verification depth matches task impact
- full verification ran when policy requires it
- If `{{REVIEWER_ENABLE_RUNTIME_VERIFICATION}} = true` and the task involves user-facing changes, runtime verification evidence must be present.

## 7.4 Reference Commands
- `{{CMD_SMOKE}}`
- `{{CMD_TEST_UNIT}}`
- `{{CMD_TEST_INTEGRATION}}`
- `{{CMD_TEST_E2E}}`
- `{{CMD_VERIFY_ALL}}`
- `{{CMD_TEST_GATE_EXTRA_1}}`
- `{{CMD_TEST_GATE_EXTRA_2}}`

## 7.5 Gate Outcomes
- **passed**: verification evidence supports continuation
- **failed**: approval blocked
- **pending**: more evidence required
- **not_evaluable**: task is not yet at a meaningful verification point

## 7.6 Policy Note
Smoke alone is sufficient only when the task’s defined impact truly does not require deeper checks.

---

## 8. Gate 5 — Regression Gate

## 8.1 Purpose
This gate determines whether the completed work introduced unacceptable adjacent breakage risk.

## 8.2 Required Conditions
The regression gate is satisfied when:

- changed surface has been identified
- adjacent risk has been assessed
- relevant surrounding checks have been executed when needed
- residual risk has been classified
- no blocking regression remains untracked

## 8.3 Risk Levels
Allowed regression risk levels:
- `low`
- `medium`
- `high`
- `unknown`

## 8.4 Policy Thresholds
Use the following policy variables:

- rejection threshold: `{{REGRESSION_RISK_THRESHOLD_FOR_REJECTION}}`
- pending threshold: `{{REGRESSION_RISK_THRESHOLD_FOR_PENDING}}`

## 8.5 Gate Outcomes
- **passed**: residual regression risk is acceptable
- **failed**: regression confirmed or risk unacceptably high
- **pending**: more adjacent validation required

---

## 9. Gate 6 — Review Gate

## 9.1 Purpose
This gate determines whether reviewer approval conditions are satisfied.

## 9.2 Required Conditions
The review gate is satisfied when:

- review is completed if policy requires review
- decision is explicit
- review reasons are explicit
- verification evidence is checked
- artifact consistency is checked
- clean-state claim is evaluated

## 9.3 Policy Variable
- `{{REQUIRE_REVIEW_AGENT}}`

If `{{REQUIRE_REVIEW_AGENT}} = true`, a task cannot move to final pass state without explicit review completion.

## 9.4 Allowed Review Outcomes
- `approved`
- `rejected`
- `pending`
- `not_required`

## 9.5 Gate Outcomes
- **passed**: reviewer conditions satisfied
- **failed**: rejection or recovery/follow-up needed
- **pending**: additional evidence or correction required

---

## 10. Gate 7 — Pass / Completion Gate

## 10.1 Purpose
This gate determines whether a task may move to final `passed` state.

## 10.2 Required Conditions
A task may be marked `passed` only when:

- repository readiness gate passed
- task selection gate passed
- implementation scope gate passed
- verification gate passed
- regression gate passed or is within acceptable threshold
- review gate passed when required
- task/artifact state is consistent
- repository is left in clean resumable state

## 10.3 Evidence Sources
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`
- `{{SESSION_SUMMARY_FILE_PATH}}`
- `{{PROGRESS_FILE_PATH}}`
- verification reports
- reviewer output

## 10.4 Blocking Conditions
A task must not be marked `passed` when:

- required verification is missing
- review is unresolved when required
- hidden blocker remains
- known issue invalidates the claim
- repository clean-state claim is false without explicit override policy

---

## 11. Gate 8 — Recovery Gate

## 11.1 Purpose
This gate determines whether the repository must move into recovery flow instead of normal task flow.

## 11.2 Recovery Triggers
Recovery gate is activated when one or more of the following is true:

- smoke fails
- baseline runtime is broken
- repository is not resumable
- critical verification fails
- rollback is safer than continued repair
- known issue blocks normal progress
- severe regression is introduced

## 11.3 Reference Commands
- `{{CMD_COLLECT_STATUS}}`
- `{{CMD_SMOKE}}`
- `scripts/rollback_last_good.sh {{ROLLBACK_TARGET_COMMIT}} "{{ROLLBACK_REASON}}"`

## 11.4 Gate Outcomes
- **passed**: healthy baseline restored
- **failed**: repository remains blocked
- **pending**: manual or follow-up recovery required

---

## 12. Gate Decision Matrix

### 12.1 If Repository Readiness Fails
Decision:
- recovery or initialization
Not Allowed:
- normal feature work

### 12.2 If Task Selection Fails
Decision:
- split, refine, or block task
Not Allowed:
- coder proceeds on ambiguous or oversized work

### 12.3 If Scope Gate Fails
Decision:
- reject or re-breakdown
Not Allowed:
- silent approval

### 12.4 If Verification Gate Fails
Decision:
- failed or pending
Not Allowed:
- pass state

### 12.5 If Regression Gate Fails
Decision:
- reject or require more evidence
Not Allowed:
- approval as safe completion

### 12.6 If Review Gate Fails
Decision:
- reject or pending
Not Allowed:
- final pass when review is required

### 12.7 If Recovery Gate Activates
Decision:
- recover baseline first
Not Allowed:
- continue normal feature session

---

## 13. Required Artifact Alignment

Every gate decision must be reflected consistently in:

- `{{CURRENT_TASK_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`
- `{{SESSION_SUMMARY_FILE_PATH}}`
- `{{PROGRESS_FILE_PATH}}`
- `{{KNOWN_ISSUES_FILE_PATH}}` when applicable

A gate is operationally incomplete if artifacts disagree about the result.

---

## 14. Quality Gate Roles

### Planner
Responsible for:
- task selection gate
- scope readiness
- decomposition quality

### Initializer
Responsible for:
- repository readiness gate baseline

### Coder
Responsible for:
- implementation scope adherence
- verification execution
- artifact updates

### Reviewer
Responsible for:
- review gate
- regression gate
- final approval decision

---

## 15. Minimum Evidence Model

The minimum acceptable evidence for a bounded task should include:

1. selected task identity
2. implementation summary
3. changed file set
4. executed verification commands
5. verification result
6. review decision when required
7. session summary
8. progress entry
9. clean-state result

Without this minimum evidence, a task should not be treated as fully complete.

---

## 16. Variable Injection Model

All project-specific gate behavior must be supplied via variables such as:

### Identity
- `{{PROJECT_NAME}}`
- `{{REPOSITORY_NAME}}`

### Runtime / Commands
- `{{CMD_BOOTSTRAP}}`
- `{{CMD_SMOKE}}`
- `{{CMD_VERIFY_ALL}}`
- `{{CMD_TEST_UNIT}}`
- `{{CMD_TEST_INTEGRATION}}`
- `{{CMD_TEST_E2E}}`
- `{{CMD_TEST_GATE_EXTRA_1}}`
- `{{CMD_TEST_GATE_EXTRA_2}}`
- `{{CMD_COLLECT_STATUS}}`

### Policy
- `{{SESSION_MAX_SCOPE}}`
- `{{REQUIRE_REVIEW_AGENT}}`
- `{{REQUIRE_FULL_VERIFY_FOR_CORE_CHANGE}}`
- `{{REGRESSION_RISK_THRESHOLD_FOR_REJECTION}}`
- `{{REGRESSION_RISK_THRESHOLD_FOR_PENDING}}`

### Paths
- `{{AGENTS_FILE_PATH}}`
- `{{PROGRESS_FILE_PATH}}`
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`
- `{{KNOWN_ISSUES_FILE_PATH}}`
- `{{SESSION_SUMMARY_FILE_PATH}}`

No project-specific hard-coded gate assumptions should remain in the template.

---

## 17. Success Criteria

The quality gate system is successful when:

1. no task can quietly skip required evidence,
2. review decisions are reproducible,
3. blocked states route to explicit next actions,
4. pass state has consistent meaning,
5. regression and recovery are handled structurally,
6. the same gate policy can be reused across sessions and roles.

---

## 18. Notes

This document should remain aligned with:
- `docs/architecture.md`
- `docs/runbook.md`
- `AGENTS.md`
- `.claude/agents/*`
- `.claude/skills/*`
- `verification/*`
- `tasks/*`
- `state/*`

When verification or approval policy changes, update this document before expecting consistent gate behavior from later sessions.