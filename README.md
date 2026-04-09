# Long-Running Coding Agent Harness

A template-based harness system for operating long-running coding agents across multiple sessions. Provides structured state management, verification gates, recovery procedures, and role-based agent orchestration.

Based on the principles from [Anthropic's Harness Design for Long-Running Application Development](https://www.anthropic.com/engineering/harness-design-long-running-apps).

## Overview

This harness enables coding agents (such as Claude Code) to:

1. **Maintain progress across sessions** using repository-based state artifacts
2. **Restrict each session to a bounded work unit** with explicit scope
3. **Enforce repeatable verification** through smoke checks, test gates, and quality gates
4. **Support recovery** when regressions or runtime failures occur
5. **Orchestrate multiple agent roles**: planner, initializer, coder, reviewer
6. **Evolve the harness** as model capabilities improve

## Quick Start

1. Clone this template into your project repository
2. Run the interactive configuration script to substitute all `{{VARIABLE}}` placeholders:
   ```bash
   bash configure.sh --interactive
   ```
   This prompts for the minimum required variables, saves them to `project_variables.json`, and applies substitutions across all template files. Alternatively, prepare a JSON config and run:
   ```bash
   bash configure.sh --config project_variables.json          # apply
   bash configure.sh --config project_variables.json --dry-run # preview changes
   bash configure.sh --generate-example                        # create a starter JSON
   ```
   See `bash configure.sh --help` for all options. For the full variable reference (170+ variables), consult the [Variable Dictionary](long_running_agent_harness_variable_dictionary.md).
3. Run bootstrap: `bash ./init.sh`
4. Run smoke verification: `bash ./verification/smoke.sh`
5. Run first planner session to select a bounded task

## Directory Structure

```text
├── AGENTS.md                       # Repository operating policy
├── init.sh                         # Bootstrap entry point
├── claude-progress.txt             # Append-only session history
├── feature_list.json               # Work item status tracking
├── tasks/
│   ├── current_task.json           # Active session task (with contract review)
│   └── backlog.json                # Work item queue
├── verification/
│   ├── smoke.sh                    # Minimum readiness check
│   └── verify_all.sh              # Full verification suite
├── scripts/
│   ├── _common.sh                  # Shared utility functions
│   ├── bootstrap_env.sh            # Structured bootstrap helper
│   ├── collect_status.sh           # Repository/runtime status collector
│   ├── commit_session.sh           # Policy-based commit helper
│   └── rollback_last_good.sh      # Rollback to known-good state
├── state/
│   ├── environment.json            # Runtime configuration
│   ├── session_summary.json        # Session result record
│   ├── known_issues.json           # Issue registry
│   └── qa_tuning_log.json         # Reviewer effectiveness tracking
├── .claude/
│   ├── agents/                     # Agent role definitions
│   └── skills/                     # Reusable skill procedures
└── docs/
    ├── architecture.md             # System architecture
    ├── runbook.md                  # Operational procedures
    ├── quality_gates.md            # Quality gate definitions
    └── harness_assumptions.md     # Model-limitation assumptions & evolution
```

## Core Concepts

### Template Variables

All project-dependent values use `{{VARIABLE_NAME}}` placeholders. Before using this harness:

1. Review the [Variable Dictionary](long_running_agent_harness_variable_dictionary.md) for all available variables (170+ documented)
2. Start with the **minimum required variable set** (Section 25 of the dictionary)
3. Substitute all `{{VARIABLE}}` references in template files with your project values

### Agent Roles

| Role | Purpose | Primary Output |
|------|---------|----------------|
| **Planner** | Selects one bounded next task, defines **what** not **how** | `tasks/current_task.json` |
| **Initializer** | Normalizes bootstrap and baseline | `init.sh`, `state/environment.json` |
| **Coder** | Implements the selected task within approved scope | Code changes, verification results |
| **Reviewer** | Validates implementation via artifact review and runtime verification | Review decision, approval/rejection |

### Session Lifecycle

```
1. Start      — Read progress, bootstrap, smoke check
2. Plan       — Select one bounded work item
3. Contract   — Reviewer validates scope & verification plan (if REQUIRE_CONTRACT_REVIEW=true)
4. Implement  — Code within approved scope
5. Verify     — Run required verification + runtime verification
6. Review     — Reviewer evaluates evidence, approves or rejects
7. Record     — Update state artifacts, append progress
8. Handoff    — Leave repository resumable for next session
```

### Quality Gates (8 sequential)

1. Repository Readiness → 2. Task Selection → 3. Implementation Scope → 4. Verification → 5. Regression → 6. Review → 7. Pass/Completion → 8. Recovery

### Harness Evolution

Each harness component encodes an assumption about what the model cannot do reliably. As models improve, these assumptions should be periodically stress-tested and components simplified or removed. See [`docs/harness_assumptions.md`](docs/harness_assumptions.md).

### QA Tuning

The reviewer participates in a continuous improvement loop. Missed issues and false rejections are tracked in `state/qa_tuning_log.json`. Periodic QA tuning sessions refine the reviewer's prompt based on accumulated evidence. See the QA Tuning Session procedure in [`docs/runbook.md`](docs/runbook.md).

## Documentation

| Document | Language | Description |
|----------|----------|-------------|
| [Standard Specification](long_running_agent_harness.md) | Korean | Authoritative harness standard |
| [Variable Dictionary](long_running_agent_harness_variable_dictionary.md) | Korean | Complete variable reference (170+ vars) |
| [Architecture](docs/architecture.md) | English | System architecture (template) |
| [Runbook](docs/runbook.md) | English | Operational procedures (template) |
| [Quality Gates](docs/quality_gates.md) | English | Gate definitions (template) |
| [Harness Assumptions](docs/harness_assumptions.md) | English | Model-limitation assumptions & evolution |
