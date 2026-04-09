# {{PROJECT_NAME}} Harness Assumptions

## Document Info
- Template Version: {{HARNESS_TEMPLATE_VERSION}}
- Document Version: {{HARNESS_ASSUMPTIONS_DOC_VERSION}}
- Created At: {{CREATED_AT}}
- Updated At: {{UPDATED_AT}}

---

## 1. Purpose

This document records the model-limitation assumptions encoded in each harness component.

Every constraint, gate, and separation of concerns in this harness exists because the model is assumed to be unreliable at a specific capability. As models improve, some assumptions become invalid and their corresponding components may be simplified or removed.

This document enables:
1. explicit tracking of why each component exists,
2. periodic reassessment of whether assumptions still hold,
3. informed evolution of the harness when models improve.

Reference: "Every component in a harness encodes an assumption about what the model can't do on its own, and those assumptions are worth stress testing." — Anthropic Labs, 2026

---

## 2. Component Assumptions

### 2.1 Agent Role Separation (Planner / Coder / Reviewer)

**Assumption:** A single agent cannot reliably plan, implement, and evaluate its own work within one session without scope drift, self-congratulation bias, or quality erosion.

**Evidence:** Anthropic research shows agents consistently overpraise their own output. Separating generation from evaluation proved more tractable than making generators self-critical.

**Stress test:** Run a session where one agent performs all three roles. Compare output quality and scope adherence against the separated model.

**When to reconsider:** When a model demonstrates consistent self-critical evaluation in blind tests across multiple task types.

### 2.2 Single Task Per Session

**Assumption:** Agents lose focus and accumulate errors when working on multiple unrelated tasks within one context window.

**Evidence:** Context management research shows coherence degrades as context fills. Bounding work to one task reduces the risk of cascading errors.

**Stress test:** Allow two bounded tasks in a single session. Compare completion quality and regression rate against single-task sessions.

**When to reconsider:** When models demonstrate reliable context management across extended multi-task sessions without quality degradation.

### 2.3 External State Files

**Assumption:** Model memory across sessions is unreliable. Progress, blockers, and decisions must be persisted in repository files to survive context resets.

**Evidence:** Context resets (clearing the window with structured handoffs) proved essential for maintaining coherence. Hidden memory cannot be verified or audited.

**Stress test:** Run consecutive sessions without reading state files, relying only on model memory. Compare handoff quality.

**When to reconsider:** When models have reliable persistent memory across sessions with verifiable recall accuracy.

### 2.4 Mandatory Verification Gates

**Assumption:** Agents will claim completion without adequate testing if not structurally forced to verify.

**Evidence:** Without verification gates, "looks right" replaces "proven correct." Planned checks are not evidence — only executed checks count.

**Stress test:** Remove verification requirements for low-risk tasks. Measure regression rate.

**When to reconsider:** When agents independently and consistently run appropriate verification without being instructed to.

### 2.5 Smoke-Before-Feature Rule

**Assumption:** Agents may attempt feature work on a broken baseline, compounding failures.

**Evidence:** Without baseline checks, agents waste sessions building on unstable foundations.

**Stress test:** Allow feature work when smoke is unknown. Measure how often agents detect and self-correct baseline issues.

**When to reconsider:** When agents reliably detect broken baselines and refuse to proceed without explicit instruction.

### 2.6 Planner Scope Constraints

**Assumption:** Without explicit scope limits, planners will select oversized tasks that exceed session capacity.

**Evidence:** Agents tend toward ambitious scoping. Bounded work units reduce the risk of incomplete sessions.

**Stress test:** Allow the planner to self-determine scope without SESSION_MAX_SCOPE constraints. Measure completion rates.

**When to reconsider:** When planners consistently select appropriately-sized tasks and self-split when needed.

### 2.7 Reviewer as Separate Agent

**Assumption:** The implementing agent cannot objectively evaluate whether its own output meets acceptance criteria.

**Evidence:** Self-evaluation studies show systematic overrating. Separate evaluators catch issues that self-review misses.

**Stress test:** Have the coder perform structured self-review using the same checklist the reviewer uses. Compare issue detection rates.

**When to reconsider:** When self-review consistently matches or exceeds independent review quality across diverse task types.

### 2.8 Recovery as First-Class Path

**Assumption:** Agents will not autonomously detect and recover from broken states without explicit recovery procedures.

**Evidence:** Without recovery protocols, broken states persist across sessions and compound.

**Stress test:** Remove explicit recovery scripts. Measure how often agents independently diagnose and fix broken states.

**When to reconsider:** When agents reliably detect regression, diagnose root causes, and restore baselines without scripted procedures.

---

## 3. Assumption Audit Procedure

### 3.1 When to Audit
- When adopting a new model version
- When a harness component consistently adds overhead without catching issues
- Quarterly, or after every {{AUDIT_INTERVAL_SESSIONS}} sessions

### 3.2 Audit Steps
1. Review each assumption in this document.
2. Collect evidence from recent sessions: Did the component catch real issues?
3. Run the suggested stress test if evidence is ambiguous.
4. Update the assumption status: `active`, `weakening`, `retired`.
5. If an assumption is retired, propose a harness simplification.

### 3.3 Audit Record
Append audit results to this document:

```
### Audit: {{AUDIT_DATE}}
- Model: {{MODEL_NAME_AND_VERSION}}
- Assumptions reviewed: [list]
- Status changes: [list]
- Harness changes: [list]
```

---

## 4. Assumption Status Summary

| ID | Component | Assumption | Status |
|----|-----------|------------|--------|
| 2.1 | Agent Role Separation | Single agent cannot plan+code+review | {{STATUS_2_1}} |
| 2.2 | Single Task Per Session | Multi-task degrades quality | {{STATUS_2_2}} |
| 2.3 | External State Files | Model memory is unreliable across sessions | {{STATUS_2_3}} |
| 2.4 | Mandatory Verification | Agents skip testing without gates | {{STATUS_2_4}} |
| 2.5 | Smoke-Before-Feature | Agents build on broken baselines | {{STATUS_2_5}} |
| 2.6 | Planner Scope Constraints | Planners select oversized tasks | {{STATUS_2_6}} |
| 2.7 | Reviewer Separation | Self-evaluation is unreliable | {{STATUS_2_7}} |
| 2.8 | Recovery First-Class | Agents don't self-recover | {{STATUS_2_8}} |

---

## 5. Template Notes

This document is a project-neutral template. Status values should be set during project initialization and updated after each audit cycle.
