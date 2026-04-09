---
name: milestone-decomposition
description: >
  Decomposes a project milestone into bounded, verifiable feature-list entries
  suitable for the planner/coder/reviewer cycle in the agent harness.
version: "{{SKILL_VERSION}}"
owner_role: strategist
applicability:
  - strategic-planning
  - milestone-decomposition
  - project-initialization
tags:
  - strategy
  - milestones
  - decomposition
  - roadmap
---

# Milestone Decomposition Skill

## 1. Purpose

Convert a milestone goal into a set of `feature_list.json` entries that are individually verifiable, properly ordered by dependency, and sized for single-session execution by the planner/coder/reviewer cycle.

---

## 2. When To Use

- Initial project planning: converting a new project goal into its first milestone's work items.
- Milestone advancement: decomposing the next milestone after the current one completes.
- Milestone re-planning: adjusting scope after strategic review identifies changes.

---

## 3. When Not To Use

- Individual task selection from an existing feature list (use planner).
- Splitting a single task into subtasks (use task-breakdown skill).
- Implementing features (use coder).

---

## 4. Inputs

| Input | Source | Required |
|-------|--------|----------|
| Milestone definition | `roadmap.json` → milestone entry | Yes |
| Project goal | `project_goal.md` | Yes (Mode A) |
| Existing features | `feature_list.json` | Yes (for ID sequencing) |
| Known issues | `state/known_issues.json` | No (for scope adjustment) |
| Progress history | `{{PROGRESS_FILE_PATH}}` | No (for lessons learned) |

---

## 5. Expected Outputs

| Output | Target | Description |
|--------|--------|-------------|
| Feature entries | `feature_list.json` | 3-{{MAX_FEATURES_PER_MILESTONE}} new entries appended |
| Updated milestone | `roadmap.json` | `feature_ids` populated, `status` updated |
| Strategic decisions | `state/strategic_review.json` | Any decisions made during decomposition |

---

## 6. Decomposition Methodology

### Step 1: Analyze Milestone Goal
Read the milestone's `goal` and `success_criteria`. Identify the capabilities that must exist when the milestone is complete.

### Step 2: Identify Required Capabilities
Break the goal into distinct functional capabilities:
- Data structures / models needed
- API endpoints or interfaces needed
- Business logic or processing needed
- Configuration or infrastructure needed
- Verification or testing needed

### Step 3: Map to Feature Items
Each capability becomes one or more feature_list.json entries. Apply these boundaries:

| Decomposition Axis | Example |
|-------------------|---------|
| **Data layer** | Database schema, migrations, seed data |
| **API contract** | Endpoint definition, request/response format |
| **Business logic** | Core processing, validation rules |
| **Integration** | External service connections, adapters |
| **Configuration** | Environment setup, deployment config |
| **Verification** | Test infrastructure, CI setup |

### Step 4: Order by Dependency
Arrange features so that:
1. Infrastructure precedes features that depend on it.
2. Data layer precedes API layer.
3. Core features precede enhancement features.
4. Each feature can be verified independently after its dependencies are met.

### Step 5: Assign Metadata
For each feature entry, determine:
- `priority`: Lower number = higher priority. Match dependency order.
- `verification_type`: "smoke" for infrastructure, "unit" for logic, "integration" for API, "e2e" for workflows.
- `risk`: "high" for core/shared changes, "medium" for new features, "low" for isolated additions.
- `estimated_scope`: "small" (1-2 files), "medium" (3-5 files), "large" (6+ files).
- `depends_on`: List feature IDs this entry depends on.
- `completion_criteria`: Observable outcomes, not implementation steps.

### Step 6: Validate
Before writing:
- Total features <= {{MAX_FEATURES_PER_MILESTONE}}
- Each feature has all required schema fields
- Dependency graph has no cycles
- Every feature has at least one completion criterion
- Every feature has at least one verification command (even if placeholder)

---

## 7. Feature Entry Schema (Required Fields)

All fields below must be present in every generated entry:

```
id, category, type, title, description, priority, status, passes,
verification_type, risk, estimated_scope, depends_on, owner_role,
selection_policy, files_expected, steps, completion_criteria,
verification_commands, rollback_strategy, notes, blocked_reason,
last_verified_at, last_verified_by, review_required,
full_verify_required, artifacts_expected
```

Default values for new entries:
- `status`: "not_started"
- `passes`: false
- `owner_role`: "coder"
- `selection_policy`: "always"
- `last_verified_at`: ""
- `last_verified_by`: ""
- `blocked_reason`: ""

---

## 8. Do Not Rules

1. Do NOT create features smaller than independently verifiable units.
2. Do NOT create features larger than a single session can implement.
3. Do NOT skip dependency ordering.
4. Do NOT leave `completion_criteria` empty.
5. Do NOT generate implementation steps in `steps` — leave for planner/coder to fill.
6. Do NOT modify existing feature_list.json entries.
7. Do NOT exceed {{MAX_FEATURES_PER_MILESTONE}} features per milestone.

---

## 9. Success Definition

Decomposition is successful when:
- All generated features conform to the existing schema.
- Features are ordered by dependency with no cycles.
- Each feature has clear, verifiable completion criteria.
- The milestone's `feature_ids` in `roadmap.json` matches the generated IDs.
- Total feature count is between 3 and {{MAX_FEATURES_PER_MILESTONE}}.
