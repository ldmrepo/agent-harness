---
name: task-breakdown
description: >
  Breaks large or ambiguous work into bounded, verifiable session-sized tasks
  that can be selected, implemented, reviewed, and handed off safely within the harness.
version: {{SKILL_VERSION}}
owner_role: planner
applicability:
  - planning
  - backlog-refinement
  - session-scoping
  - long-running-agent-harness
tags:
  - planning
  - task-breakdown
  - scoping
  - backlog
  - session-design
---

# Task Breakdown Skill

## 1. Purpose

This skill converts high-level work into **small, bounded, verifiable tasks** suitable for the long-running coding-agent harness.

Use this skill when work is:
- too large,
- too vague,
- too risky,
- too coupled,
- or not yet shaped into a session-sized implementation unit.

This skill exists to prevent:
- oversized sessions,
- ambiguous implementation,
- unclear verification,
- hidden dependency chains,
- poor handoff quality.

---

## 2. When To Use

Use this skill when one or more of the following is true:

1. a backlog item is too large for `{{SESSION_MAX_SCOPE}}`,
2. a selected task has unclear acceptance criteria,
3. dependencies are mixed together in one task,
4. multiple user-visible behaviors are bundled together,
5. verification for the task is not obvious,
6. the planner cannot confidently hand off one bounded work item,
7. a task repeatedly fails because it is too broad.

---

## 3. When Not To Use

Do not use this skill when:

1. the current task is already small and well-bounded,
2. the selected task already has clear scope and verification,
3. the problem is not task size but broken runtime/recovery state,
4. the repository policy requires execution rather than further decomposition.

Do not split purely for formality.
Split only when it improves implementation and review quality.

---

## 4. Inputs

This skill expects the following artifacts when present:

- `{{FEATURE_LIST_FILE_PATH}}`
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`
- `{{PROGRESS_FILE_PATH}}`
- `{{KNOWN_ISSUES_FILE_PATH}}`
- `{{ENVIRONMENT_FILE_PATH}}`

It may also inspect:
- previous session summaries,
- rejection notes,
- verification reports,
- git history,
- existing file layout,
- known dependencies or blockers.

---

## 5. Expected Outputs

This skill should create, update, or refine:

### Primary Outputs
- `{{BACKLOG_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`

### Optional Outputs
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{SESSION_SUMMARY_FILE_PATH}}`

Each resulting task should include at minimum:
- task id,
- title,
- description,
- priority,
- status,
- verification type,
- dependencies,
- bounded scope,
- completion criteria.

---

## 6. Breakdown Principles

### 6.1 One Task, One Dominant Purpose
A task should have one main purpose.
If it has multiple independent goals, split it.

### 6.2 Break by Meaningful Boundary
Prefer splits along real boundaries:
- user flow step
- API contract step
- state transition
- data dependency
- verification boundary
- file cluster
- runtime layer

### 6.3 Preserve End-to-End Meaning
Do not split into meaningless fragments that cannot be verified on their own.

### 6.4 Make Verification Obvious
Every split task should have a clear verification path.

### 6.5 Keep Dependencies Explicit
If one subtask enables another, record that relationship.
Do not hide ordering assumptions.

---

## 7. Required Variables

The following variables must be available or resolvable:

### Paths
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`
- `{{PROGRESS_FILE_PATH}}`
- `{{KNOWN_ISSUES_FILE_PATH}}`
- `{{SESSION_SUMMARY_FILE_PATH}}`

### Policy
- `{{SESSION_MAX_SCOPE}}`
- `{{ALLOW_PARALLEL_TASKS}}`
- `{{MAX_ACTIVE_TASKS}}`
- `{{BACKLOG_SELECTION_STRATEGY}}`
- `{{REQUIRE_REVIEW_AGENT}}`
- `{{REQUIRE_FULL_VERIFY_FOR_CORE_CHANGE}}`

### Verification Commands
- `{{CMD_SMOKE}}`
- `{{CMD_TEST_UNIT}}`
- `{{CMD_TEST_INTEGRATION}}`
- `{{CMD_TEST_E2E}}`
- `{{CMD_VERIFY_ALL}}`

---

## 8. Step-by-Step Procedure

### Step 1. Identify the Oversized or Ambiguous Work
Locate the target item and determine why it cannot be safely executed as-is.

Common reasons:
- too many files,
- too many behaviors,
- no clear acceptance criteria,
- unclear verification,
- mixed dependencies,
- high regression risk.

### Step 2. Determine Natural Split Axes
Choose the most appropriate split axis:

- user journey
- API lifecycle
- state machine boundary
- persistence boundary
- rendering boundary
- background worker boundary
- verification boundary

Do not use arbitrary line-count or file-count only splits unless no better structure exists.

### Step 3. Draft Candidate Subtasks
For each candidate subtask, define:
- title
- description
- purpose
- in-scope meaning
- expected changed files
- verification type
- completion criteria
- dependencies

### Step 4. Check Task Size
Reject a candidate subtask if it still exceeds `{{SESSION_MAX_SCOPE}}`.

A task is too large if it likely requires:
- multiple unrelated file clusters,
- multiple workflows,
- multiple independent verifications,
- broad architectural decisions.

### Step 5. Check Verification Readiness
Every candidate subtask must map to one or more of:
- `{{CMD_SMOKE}}`
- `{{CMD_TEST_UNIT}}`
- `{{CMD_TEST_INTEGRATION}}`
- `{{CMD_TEST_E2E}}`
- `{{CMD_VERIFY_ALL}}`

If no meaningful verification exists, the task is not ready.

### Step 6. Order the Subtasks
Define dependency order explicitly.
Prefer forward progress with minimal blocking chains.

### Step 7. Update Planning Artifacts
Write the refined items into:
- backlog,
- feature list,
- and current task if selection occurs immediately.

---

## 9. Task Sizing Rules

A good task should usually satisfy most of these:

- one dominant purpose,
- one primary verification mode,
- limited file spread,
- limited regression surface,
- explicit acceptance criteria,
- understandable next step,
- implementable without hidden design leaps.

A task is too small if it:
- cannot be verified independently,
- has no user-visible or technically meaningful milestone,
- creates bookkeeping overhead without reducing ambiguity.

A task is too large if it:
- spans multiple systems,
- requires multiple unrelated validations,
- bundles enabling work and feature work together,
- includes large refactoring plus new behavior in one item.

---

## 10. Dependency Rules

When breaking down tasks:

1. mark explicit dependencies,
2. avoid unnecessary dependency chains,
3. prefer parallelizable items only if policy allows,
4. isolate blockers into enabling tasks when necessary,
5. never assume order implicitly.

If a blocker dominates execution, create a recovery/enabling task first.

---

## 11. Verification Mapping Rules

For each task, define the minimum appropriate verification level:

### Smoke
Use when:
- the task affects boot/run readiness,
- the task affects minimum runtime availability.

### Unit
Use when:
- logic is isolated,
- internal behavior is the main target.

### Integration
Use when:
- service or module interaction matters.

### E2E
Use when:
- user-visible behavior or end-to-end flow matters.

### Full Verification
Use when:
- core/shared systems are affected,
- repository policy requires broad validation.

Do not assign overly broad verification if a narrower one is sufficient, unless policy requires broader gates.

---

## 12. Output Format Rules

Each generated task should include:

- task id
- title
- type
- category
- description
- priority
- status
- passes
- risk level
- estimated scope
- owner role
- dependency list
- expected files
- completion criteria
- verification type
- review requirement
- full verification requirement
- notes / blockers if relevant

Use the repository task schema instead of prose whenever possible.

---

## 13. Example Breakdown Template

Use the following structure when generating subtasks:

### Parent Work
- {{PARENT_WORK_ID}}
- {{PARENT_WORK_TITLE}}

### Proposed Subtasks
1. `{{SUBTASK_ID_1}}` — {{SUBTASK_TITLE_1}}
   - purpose: {{SUBTASK_PURPOSE_1}}
   - verification: {{SUBTASK_VERIFY_1}}
   - depends_on: {{SUBTASK_DEP_1}}

2. `{{SUBTASK_ID_2}}` — {{SUBTASK_TITLE_2}}
   - purpose: {{SUBTASK_PURPOSE_2}}
   - verification: {{SUBTASK_VERIFY_2}}
   - depends_on: {{SUBTASK_DEP_2}}

3. `{{SUBTASK_ID_3}}` — {{SUBTASK_TITLE_3}}
   - purpose: {{SUBTASK_PURPOSE_3}}
   - verification: {{SUBTASK_VERIFY_3}}
   - depends_on: {{SUBTASK_DEP_3}}

### Recommended First Selectable Task
- {{FIRST_SELECTABLE_TASK}}

---

## 14. Failure Handling

If meaningful breakdown is not possible:

1. record why,
2. identify the missing information,
3. identify the blocker type,
4. recommend the smallest enabling task,
5. avoid pretending the task is ready.

Do not hand off an unimplementable task as if it were well-scoped.

---

## 15. Do Not Rules

- Do not split tasks arbitrarily.
- Do not create subtasks without verification paths.
- Do not keep hidden dependencies implicit.
- Do not turn one clear task into excessive bureaucracy.
- Do not leave ambiguous ownership.
- Do not generate giant subtasks that still violate `{{SESSION_MAX_SCOPE}}`.

---

## 16. Success Definition

This skill succeeds when:

1. oversized work becomes session-sized work,
2. each resulting task has clear scope,
3. each resulting task has clear verification,
4. dependency order is explicit,
5. planner can confidently choose the next task,
6. coder can implement without guessing.

---

## 17. Notes

This skill is intended to be reused by:
- planner agent
- backlog refinement sessions
- rejection recovery after overscoped work
- milestone decomposition passes

It is not a replacement for implementation or review.
It is a scoping and structuring skill.