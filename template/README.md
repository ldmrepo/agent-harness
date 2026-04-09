# {{PROJECT_NAME}}

> This project uses a long-running coding agent harness.

## Quick Start

```bash
# 1. Configure variables
bash configure.sh --interactive

# 2. Bootstrap
bash ./init.sh

# 3. Smoke verification
bash ./verification/smoke.sh

# 4. Start first planner session
```

## Session Lifecycle

```
1. Start      → Read state files, bootstrap, smoke check
2. Plan       → Select one bounded work item
3. Contract   → Reviewer validates scope & verification plan
4. Implement  → Code within approved scope
5. Verify     → Smoke + feature-level + runtime verification
6. Review     → Reviewer evaluates evidence
7. Record     → Update state artifacts, append progress
8. Handoff    → Leave repository resumable
```

## Agent Roles

| Role | Purpose |
|------|---------|
| **Planner** | Selects one bounded next task |
| **Reviewer** | Contract review + implementation review |
| **Coder** | Implements within approved scope |
| **Initializer** | Normalizes bootstrap and baseline |

## Orchestrator

```bash
bash orchestrator.sh --max-sessions 20 --max-hours 4      # autonomous run
bash orchestrator.sh --dry-run                              # preview only
```

## Documentation

- `AGENTS.md` — Operating policy
- `docs/architecture.md` — System architecture
- `docs/runbook.md` — Operational procedures
- `docs/quality_gates.md` — Quality gate definitions
- `docs/harness_assumptions.md` — Harness evolution tracking
