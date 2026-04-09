---
name: repo-bootstrap
description: >
  Establishes a reproducible repository bootstrap path for long-running agent sessions,
  including execution entry points, state artifacts, smoke readiness, and baseline environment normalization.
version: {{SKILL_VERSION}}
owner_role: initializer
applicability:
  - bootstrap
  - repository-setup
  - initialization
  - long-running-agent-harness
tags:
  - bootstrap
  - init
  - harness
  - reproducibility
  - repository-setup
---

# Repo Bootstrap Skill

## 1. Purpose

This skill standardizes how a repository becomes **bootstrappable, runnable, and resumable** for long-running agent workflows.

Use this skill when the repository needs:
- a known bootstrap path,
- a known smoke check path,
- normalized environment assumptions,
- baseline state artifacts,
- a reliable starting point for planner/coder/reviewer agents.

---

## 2. When To Use

Use this skill when one or more of the following is true:

1. `{{INIT_SCRIPT_PATH}}` is missing or unclear.
2. the repository does not have a clear run/install flow.
3. smoke verification is missing or undefined.
4. required harness artifacts are missing.
5. a repository is being initialized for the first long-running session.
6. a repository has drifted and bootstrap assumptions are no longer reliable.

---

## 3. When Not To Use

Do not use this skill as the primary action when:

1. the repository already has a stable and validated bootstrap path,
2. the selected task is purely feature implementation,
3. the real issue is not bootstrap but runtime recovery for a known breakage,
4. the repository policy forbids initialization changes in the current session.

In those cases, use the minimal preserving behavior instead of re-bootstrap.

---

## 4. Inputs

This skill expects the following repository artifacts when present:

- `{{AGENTS_FILE_PATH}}`
- `{{ENVIRONMENT_FILE_PATH}}`
- `{{PROGRESS_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`
- `{{KNOWN_ISSUES_FILE_PATH}}`

It may also inspect:
- runtime manifests
- lockfiles
- existing shell scripts
- test configuration
- CI files
- docker/compose files
- recent git history

---

## 5. Expected Outputs

This skill should create or normalize:

### Core Bootstrap Outputs
- `{{INIT_SCRIPT_PATH}}`
- `{{BOOTSTRAP_SUMMARY_FILE_PATH}}`

### Core Verification Outputs
- `{{SMOKE_SCRIPT_PATH}}`
- `{{VERIFY_ALL_SCRIPT_PATH}}`

### Core State Outputs
- `{{PROGRESS_FILE_PATH}}`
- `{{FEATURE_LIST_FILE_PATH}}`
- `{{CURRENT_TASK_FILE_PATH}}`
- `{{BACKLOG_FILE_PATH}}`
- `{{KNOWN_ISSUES_FILE_PATH}}`
- `{{SESSION_SUMMARY_FILE_PATH}}`

### Environment Outputs
- `{{ENVIRONMENT_FILE_PATH}}`

---

## 6. Bootstrap Principles

### 6.1 Reuse Existing Project Reality
Prefer existing commands and conventions over invented ones.

### 6.2 Keep Bootstrap Minimal but Sufficient
Bootstrap should do only what is necessary to reach a stable runnable baseline.

### 6.3 Separate Optional Steps
Use flags or variable-controlled sections for:
- install
- infra up
- db migrate
- app start
- worker start
- health check
- post-bootstrap actions

### 6.4 Write State Explicitly
Bootstrap should emit or refresh machine-readable state artifacts.

### 6.5 Bias Toward Idempotence
Repeated bootstrap runs should be safe when possible.

---

## 7. Required Variables

The following variables must be available or resolvable:

### Project Identity
- `{{PROJECT_NAME}}`
- `{{REPOSITORY_NAME}}`
- `{{PRIMARY_STACK}}`
- `{{RUNTIME_TYPE}}`

### Paths
- `{{INIT_SCRIPT_PATH}}`
- `{{SMOKE_SCRIPT_PATH}}`
- `{{VERIFY_ALL_SCRIPT_PATH}}`
- `{{ENVIRONMENT_FILE_PATH}}`
- `{{BOOTSTRAP_SUMMARY_FILE_PATH}}`
- `{{STATE_DIR_NAME}}`
- `{{LOG_DIR_NAME}}`
- `{{PID_DIR_NAME}}`

### Commands
- `{{CMD_INSTALL}}`
- `{{CMD_INFRA_UP}}`
- `{{CMD_DB_MIGRATE}}`
- `{{CMD_DEV}}`
- `{{CMD_WORKER}}`
- `{{CMD_SMOKE}}`
- `{{CMD_VERIFY_ALL}}`

### Health / Runtime
- `{{HEALTHCHECK_URL}}`
- `{{BOOTSTRAP_WAIT_SECONDS}}`

### Policy Flags
- `{{BOOTSTRAP_ENABLE_INSTALL}}`
- `{{BOOTSTRAP_ENABLE_INFRA}}`
- `{{BOOTSTRAP_ENABLE_DB_MIGRATE}}`
- `{{BOOTSTRAP_ENABLE_PREFLIGHT}}`
- `{{BOOTSTRAP_ENABLE_APP_START}}`
- `{{BOOTSTRAP_ENABLE_WORKER_START}}`
- `{{BOOTSTRAP_ENABLE_HEALTHCHECK}}`
- `{{BOOTSTRAP_ENABLE_POST_BOOTSTRAP}}`

---

## 8. Step-by-Step Procedure

### Step 1. Inspect Existing Execution Reality
Determine:
- package manager
- install command
- app start command
- worker existence
- infra dependencies
- migration requirement
- healthcheck path
- existing scripts

Record mismatches instead of hiding them.

### Step 2. Normalize Environment Assumptions
Ensure:
- env file reference is known
- ports/hosts are externalized
- state/log/pid directories are defined
- project runtime facts are captured in `{{ENVIRONMENT_FILE_PATH}}`

### Step 3. Create or Update Bootstrap Script
Create or refine `{{INIT_SCRIPT_PATH}}` so it can:
- optionally install dependencies
- optionally bring up infra
- optionally run migrations
- optionally start app
- optionally start worker
- optionally run health check
- write bootstrap summary

### Step 4. Create or Update Smoke Gate
Create or refine `{{SMOKE_SCRIPT_PATH}}` so it can:
- verify repository marker files
- optionally verify process/port/health
- fail fast on missing baseline readiness

### Step 5. Create or Update Full Verification Gate
Create or refine `{{VERIFY_ALL_SCRIPT_PATH}}` so it can:
- orchestrate lint/type/test/build checks
- follow project flags
- write a verification report

### Step 6. Ensure State Artifacts Exist
Create valid placeholders if missing:
- progress
- feature list
- current task
- backlog
- known issues
- session summary

### Step 7. Validate Baseline
If safe:
- run bootstrap
- run smoke

Record failures explicitly.

### Step 8. Emit Handoff
Leave clear initialization notes for the next session.

---

## 9. File Creation Rules

When creating files:

1. preserve the fixed harness folder structure,
2. use variables for all project-dependent content,
3. avoid hard-coded ports/commands,
4. avoid embedding stack-specific assumptions unless already confirmed,
5. create the smallest useful valid file.

When updating existing files:
- patch carefully,
- preserve repository-owned meaning,
- do not overwrite unrelated content blindly.

---

## 10. Validation Checklist

A repository bootstrap is acceptable only if:

- [ ] bootstrap path exists
- [ ] smoke path exists
- [ ] environment baseline exists
- [ ] progress file exists
- [ ] feature list exists
- [ ] backlog exists
- [ ] current task exists or valid empty placeholder exists
- [ ] known issues file exists
- [ ] session summary structure exists
- [ ] repository assumptions are externalized

Optional but recommended:
- [ ] bootstrap run tested
- [ ] smoke run tested
- [ ] bootstrap summary generated

---

## 11. Failure Handling

If bootstrap cannot be fully normalized:

1. record what is missing,
2. identify which command/path is ambiguous,
3. identify whether the issue is initialization or recovery,
4. leave the repository resumable,
5. add known issue entries if needed.

Do not falsely report a successful initialization.

---

## 12. Output Template

Use this structure after applying the skill:

### Bootstrap Summary
- {{BOOTSTRAP_SUMMARY_1}}
- {{BOOTSTRAP_SUMMARY_2}}
- {{BOOTSTRAP_SUMMARY_3}}

### Files Created or Updated
- {{UPDATED_FILE_1}}
- {{UPDATED_FILE_2}}
- {{UPDATED_FILE_3}}
- {{UPDATED_FILE_4}}

### Execution Paths
- bootstrap: {{CMD_BOOTSTRAP}}
- smoke: {{CMD_SMOKE}}
- verify_all: {{CMD_VERIFY_ALL}}

### Known Gaps
- {{KNOWN_GAP_1}}
- {{KNOWN_GAP_2}}

### Recommended Next Step
- {{NEXT_STEP_1}}
- {{NEXT_STEP_2}}

---

## 13. Do Not Rules

- Do not bootstrap by guessing unsupported commands when repository facts exist.
- Do not turn initialization into broad feature work.
- Do not hard-code project-specific values where variables are required.
- Do not hide failing baseline checks.
- Do not delete valid repository-owned setup files without cause.
- Do not leave state artifacts missing.

---

## 14. Success Definition

This skill succeeds when:

1. repository bootstrap is explicit,
2. smoke gate is explicit,
3. baseline state artifacts exist,
4. environment assumptions are externalized,
5. later agents can continue with reduced ambiguity.

---

## 15. Notes

This skill is intended to be reused by:
- initializer agent
- recovery-oriented setup sessions
- repository onboarding flows
- long-running harness normalization passes

It is not a substitute for feature planning or implementation.