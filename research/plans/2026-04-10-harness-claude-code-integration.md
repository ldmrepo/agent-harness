# Harness Claude Code Integration Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Claude Code의 Hooks, CLI 헤드리스 모드, Rules 기능을 활용하여 하네스 정책을 결정적으로 강제하고, 오케스트레이션을 자동화한다.

**Architecture:** 3개 레이어로 구성한다. (1) `.claude/settings.json`에 Hooks를 정의하여 하네스 정책을 코드로 강제, (2) `.claude/rules/`에 역할별 조건부 규칙 분리, (3) `orchestrator.sh`로 CLI 헤드리스 모드 기반 자동 세션 순환.

**Tech Stack:** Bash, Python3 (JSON 처리), Claude Code CLI (`-p`, `--agent`, `--permission-mode`), Claude Code Hooks (command type)

---

## File Structure

```
.claude/
├── settings.json                          # Hook 정의 (7개 이벤트)
├── hooks/
│   ├── check-smoke-before-edit.sh         # smoke 실패 시 Edit/Write 차단
│   ├── check-contract-before-edit.sh      # contract 미승인 시 Edit 차단
│   ├── check-scope-before-edit.sh         # 범위 밖 파일 수정 차단
│   ├── post-edit-verify.sh               # 코드 수정 후 자동 린트/테스트
│   ├── task-complete-gate.sh             # 작업 완료 시 검증 게이트
│   ├── stop-progress-gate.sh             # 세션 종료 시 progress 기록 강제
│   └── block-dangerous-commands.sh       # rm -rf, git push --force 차단
├── rules/
│   ├── planner-rules.md                  # planner 접근 파일 규칙
│   ├── coder-rules.md                    # coder 접근 파일 규칙
│   └── reviewer-rules.md                # reviewer 접근 파일 규칙
orchestrator.sh                            # CLI 기반 자동 오케스트레이션 루프
```

---

### Task 1: Hook 인프라 — settings.json 생성

**Files:**
- Create: `.claude/settings.json`
- Create: `.claude/hooks/block-dangerous-commands.sh`

- [ ] **Step 1: `.claude/settings.json` 생성**

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "if": "Bash(rm -rf *)",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/block-dangerous-commands.sh",
            "timeout": 5
          }
        ]
      },
      {
        "matcher": "Bash",
        "if": "Bash(git push --force*)",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/block-dangerous-commands.sh",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 2: `block-dangerous-commands.sh` 작성**

```bash
#!/usr/bin/env bash
set -euo pipefail

# block-dangerous-commands.sh
# PreToolUse hook: 위험한 bash 명령을 차단한다.
# Input: stdin JSON with tool_name, tool_input
# Output: JSON with permissionDecision

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))")

BLOCKED=false
REASON=""

# rm -rf 차단
if echo "$COMMAND" | grep -qE 'rm\s+(-[a-zA-Z]*r[a-zA-Z]*f|--recursive.*--force|-rf|-fr)'; then
  BLOCKED=true
  REASON="rm -rf 명령은 하네스 정책에 의해 차단됩니다."
fi

# git push --force 차단
if echo "$COMMAND" | grep -qE 'git\s+push\s+.*--force'; then
  BLOCKED=true
  REASON="git push --force는 하네스 정책에 의해 차단됩니다."
fi

# git reset --hard (rollback 스크립트 외) 차단
if echo "$COMMAND" | grep -qE 'git\s+reset\s+--hard' && ! echo "$COMMAND" | grep -q 'rollback_last_good'; then
  BLOCKED=true
  REASON="git reset --hard는 scripts/rollback_last_good.sh를 통해서만 허용됩니다."
fi

if [ "$BLOCKED" = "true" ]; then
  echo "{\"hookSpecificOutput\":{\"permissionDecision\":\"deny\"},\"systemMessage\":\"[HOOK] $REASON\"}" >&2
  exit 2
fi

echo "{}"
exit 0
```

- [ ] **Step 3: 실행 권한 부여**

Run: `chmod +x .claude/hooks/block-dangerous-commands.sh`

- [ ] **Step 4: 커밋**

```bash
git add .claude/settings.json .claude/hooks/block-dangerous-commands.sh
git commit -m "feat(hooks): add settings.json and dangerous command blocker"
```

---

### Task 2: Smoke 실패 시 Edit/Write 차단 Hook

**Files:**
- Create: `.claude/hooks/check-smoke-before-edit.sh`
- Modify: `.claude/settings.json`

- [ ] **Step 1: `check-smoke-before-edit.sh` 작성**

```bash
#!/usr/bin/env bash
set -euo pipefail

# check-smoke-before-edit.sh
# PreToolUse hook: smoke_report.json이 failed이면 Edit/Write를 차단한다.
# 신규 파일(테스트, 설정) 작성은 허용하되, 기존 앱 코드 수정을 차단한다.

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SMOKE_REPORT="${ROOT_DIR}/state/smoke_report.json"

# smoke report가 없으면 통과 (아직 실행 안 된 상태)
if [ ! -f "$SMOKE_REPORT" ]; then
  echo "{}"
  exit 0
fi

# smoke 결과 확인
SMOKE_RESULT=$(python3 -c "
import json, sys
try:
    with open('$SMOKE_REPORT') as f:
        data = json.load(f)
    print(data.get('result', 'unknown'))
except:
    print('unknown')
")

if [ "$SMOKE_RESULT" = "failed" ]; then
  # 복구 관련 파일 수정은 허용
  INPUT=$(cat)
  FILE_PATH=$(echo "$INPUT" | python3 -c "
import json, sys
d = json.load(sys.stdin)
ti = d.get('tool_input', {})
print(ti.get('file_path', ti.get('path', '')))
")

  # verification/, scripts/, state/ 파일 수정은 복구 작업으로 허용
  if echo "$FILE_PATH" | grep -qE '^(verification/|scripts/|state/|\.claude/)'; then
    echo "{}"
    exit 0
  fi

  echo "{\"hookSpecificOutput\":{\"permissionDecision\":\"deny\"},\"systemMessage\":\"[HOOK] smoke 검증이 실패한 상태입니다. 앱 코드 수정 전에 smoke를 복구하세요. (bash ./verification/smoke.sh)\"}" >&2
  exit 2
fi

echo "{}"
exit 0
```

- [ ] **Step 2: settings.json에 hook 추가**

`.claude/settings.json`의 `PreToolUse` 배열에 추가:

```json
{
  "matcher": "Edit|Write",
  "hooks": [
    {
      "type": "command",
      "command": "bash .claude/hooks/check-smoke-before-edit.sh",
      "timeout": 10
    }
  ]
}
```

- [ ] **Step 3: 실행 권한 부여**

Run: `chmod +x .claude/hooks/check-smoke-before-edit.sh`

- [ ] **Step 4: 커밋**

```bash
git add .claude/hooks/check-smoke-before-edit.sh .claude/settings.json
git commit -m "feat(hooks): block edits when smoke verification is failing"
```

---

### Task 3: Contract 미승인 시 구현 차단 Hook

**Files:**
- Create: `.claude/hooks/check-contract-before-edit.sh`
- Modify: `.claude/settings.json`

- [ ] **Step 1: `check-contract-before-edit.sh` 작성**

```bash
#!/usr/bin/env bash
set -euo pipefail

# check-contract-before-edit.sh
# PreToolUse hook: REQUIRE_CONTRACT_REVIEW=true일 때
# contract_status가 approved가 아니면 앱 코드 Edit/Write를 차단한다.

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
CURRENT_TASK="${ROOT_DIR}/tasks/current_task.json"

# current_task.json이 없으면 통과
if [ ! -f "$CURRENT_TASK" ]; then
  echo "{}"
  exit 0
fi

# contract_status 확인
CONTRACT_STATUS=$(python3 -c "
import json, sys
try:
    with open('$CURRENT_TASK') as f:
        data = json.load(f)
    cr = data.get('contract_review', {})
    print(cr.get('contract_status', 'not_required'))
except:
    print('not_required')
")

# approved 또는 not_required이면 통과
if [ "$CONTRACT_STATUS" = "approved" ] || [ "$CONTRACT_STATUS" = "not_required" ]; then
  echo "{}"
  exit 0
fi

# 하네스/설정 파일 수정은 허용
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | python3 -c "
import json, sys
d = json.load(sys.stdin)
ti = d.get('tool_input', {})
print(ti.get('file_path', ti.get('path', '')))
")

if echo "$FILE_PATH" | grep -qE '^(tasks/|state/|\.claude/|docs/|verification/|scripts/)'; then
  echo "{}"
  exit 0
fi

echo "{\"hookSpecificOutput\":{\"permissionDecision\":\"deny\"},\"systemMessage\":\"[HOOK] contract_status=$CONTRACT_STATUS — 계약이 승인되지 않았습니다. reviewer의 contract review를 먼저 받으세요.\"}" >&2
exit 2
```

- [ ] **Step 2: settings.json에 hook 추가**

`.claude/settings.json`의 `PreToolUse` 배열에 추가:

```json
{
  "matcher": "Edit|Write",
  "hooks": [
    {
      "type": "command",
      "command": "bash .claude/hooks/check-contract-before-edit.sh",
      "timeout": 10
    }
  ]
}
```

- [ ] **Step 3: 실행 권한 부여 + 커밋**

```bash
chmod +x .claude/hooks/check-contract-before-edit.sh
git add .claude/hooks/check-contract-before-edit.sh .claude/settings.json
git commit -m "feat(hooks): block edits when contract review is pending"
```

---

### Task 4: 세션 종료 시 Progress 기록 강제 Hook

**Files:**
- Create: `.claude/hooks/stop-progress-gate.sh`
- Modify: `.claude/settings.json`

- [ ] **Step 1: `stop-progress-gate.sh` 작성**

```bash
#!/usr/bin/env bash
set -euo pipefail

# stop-progress-gate.sh
# Stop hook: 세션 종료 전에 claude-progress.txt에 현재 세션 엔트리가
# 기록되었는지 확인한다. 없으면 종료를 차단한다.

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
PROGRESS_FILE="${ROOT_DIR}/claude-progress.txt"

# progress 파일이 없으면 차단
if [ ! -f "$PROGRESS_FILE" ]; then
  echo "{\"hookSpecificOutput\":{\"decision\":\"block\"},\"systemMessage\":\"[HOOK] claude-progress.txt가 존재하지 않습니다. 세션 종료 전에 progress 엔트리를 작성하세요.\"}"
  exit 0
fi

# 오늘 날짜의 세션 엔트리가 있는지 확인
TODAY=$(date +%Y-%m-%d)
if grep -q "$TODAY" "$PROGRESS_FILE"; then
  echo "{}"
  exit 0
fi

# stop_hook_active 플래그로 무한 루프 방지
INPUT=$(cat)
STOP_HOOK_ACTIVE=$(echo "$INPUT" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    print(str(d.get('stop_hook_active', False)).lower())
except:
    print('false')
" 2>/dev/null || echo "false")

if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  echo "{}"
  exit 0
fi

echo "{\"hookSpecificOutput\":{\"decision\":\"block\"},\"systemMessage\":\"[HOOK] 오늘 날짜의 progress 엔트리가 없습니다. claude-progress.txt에 세션 결과를 기록한 후 종료하세요.\"}"
exit 0
```

- [ ] **Step 2: settings.json에 Stop hook 추가**

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/stop-progress-gate.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 3: 실행 권한 부여 + 커밋**

```bash
chmod +x .claude/hooks/stop-progress-gate.sh
git add .claude/hooks/stop-progress-gate.sh .claude/settings.json
git commit -m "feat(hooks): enforce progress entry before session stop"
```

---

### Task 5: 코드 수정 후 자동 린트/테스트 Hook

**Files:**
- Create: `.claude/hooks/post-edit-verify.sh`
- Modify: `.claude/settings.json`

- [ ] **Step 1: `post-edit-verify.sh` 작성**

```bash
#!/usr/bin/env bash
set -euo pipefail

# post-edit-verify.sh
# PostToolUse hook (async): Edit/Write 후 자동으로 린트를 실행한다.
# 비동기 실행으로 차단하지 않으며, 결과를 systemMessage로 전달한다.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | python3 -c "
import json, sys
d = json.load(sys.stdin)
ti = d.get('tool_input', {})
print(ti.get('file_path', ti.get('path', '')))
")

# 소스 코드 파일만 대상
case "$FILE_PATH" in
  *.py)
    # Python: ruff check (설치되어 있으면)
    if command -v ruff >/dev/null 2>&1; then
      RESULT=$(ruff check "$FILE_PATH" 2>&1 || true)
      if [ -n "$RESULT" ]; then
        echo "{\"systemMessage\":\"[AUTO-LINT] ruff $FILE_PATH:\\n$RESULT\"}"
        exit 0
      fi
    fi
    ;;
  *.ts|*.tsx|*.js|*.jsx)
    # JS/TS: eslint (설치되어 있으면)
    if command -v npx >/dev/null 2>&1; then
      RESULT=$(npx eslint "$FILE_PATH" 2>&1 || true)
      if [ -n "$RESULT" ] && ! echo "$RESULT" | grep -q "0 problems"; then
        echo "{\"systemMessage\":\"[AUTO-LINT] eslint $FILE_PATH:\\n$RESULT\"}"
        exit 0
      fi
    fi
    ;;
esac

echo "{}"
exit 0
```

- [ ] **Step 2: settings.json에 PostToolUse hook 추가**

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/post-edit-verify.sh",
            "timeout": 30,
            "async": true
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 3: 실행 권한 부여 + 커밋**

```bash
chmod +x .claude/hooks/post-edit-verify.sh
git add .claude/hooks/post-edit-verify.sh .claude/settings.json
git commit -m "feat(hooks): auto-lint after code edits (async)"
```

---

### Task 6: Rules 기반 역할별 규칙 분리

**Files:**
- Create: `.claude/rules/planner-rules.md`
- Create: `.claude/rules/coder-rules.md`
- Create: `.claude/rules/reviewer-rules.md`

- [ ] **Step 1: `.claude/rules/planner-rules.md` 작성**

```markdown
---
paths:
  - "tasks/**"
  - "feature_list.json"
---

# Planner Rules

- 작업 선택 시 feature_list.json의 의존성과 우선순위를 반드시 확인한다.
- "무엇을(what)" 정의하되 "어떻게(how)"는 지정하지 않는다.
- 파일 목록(files_expected)은 참고용이며 coder가 최종 결정한다.
- 한 세션에 하나의 작업만 선택한다.
- smoke가 실패한 상태면 기능 작업 대신 복구 작업을 선택한다.
- current_task.json 작성 후 contract_status를 pending_review로 설정한다.
```

- [ ] **Step 2: `.claude/rules/coder-rules.md` 작성**

```markdown
---
paths:
  - "app/**"
  - "src/**"
  - "tests/**"
---

# Coder Rules

- contract_status가 approved가 아니면 구현을 시작하지 않는다.
- current_task.json의 in_scope에 명시된 범위 내에서만 작업한다.
- 관련 없는 리팩토링, 코드 정리, 주석 추가를 하지 않는다.
- 검증을 실행한 후 결과를 기록한다. 검증 없이 완료를 선언하지 않는다.
- smoke가 실패하면 즉시 구현을 중단하고 복구를 우선한다.
- 세션 종료 전에 claude-progress.txt에 엔트리를 추가한다.
```

- [ ] **Step 3: `.claude/rules/reviewer-rules.md` 작성**

```markdown
---
paths:
  - "state/**"
  - "verification/**"
---

# Reviewer Rules

- 증거 기반으로만 판단한다. "아마 괜찮을 것"은 승인 사유가 아니다.
- 판단이 애매하면 [QA-UNCERTAIN]을 기록한다.
- 증거 부족한데 승인하려는 유혹이 있으면 [QA-RATIONALIZATION-RISK]를 기록한다.
- 범위 준수를 가장 먼저 확인한다. 범위 밖 변경은 즉시 반려한다.
- 런타임 검증이 가능하면 실행 중인 앱을 직접 테스트한다.
- 놓친 이슈가 발견되면 state/qa_tuning_log.json에 기록한다.
```

- [ ] **Step 4: 커밋**

```bash
git add .claude/rules/
git commit -m "feat(rules): add path-scoped rules for planner, coder, reviewer"
```

---

### Task 7: CLI 오케스트레이터 스크립트

**Files:**
- Create: `orchestrator.sh`

- [ ] **Step 1: `orchestrator.sh` 작성**

```bash
#!/usr/bin/env bash
set -euo pipefail

# =========================================================
# orchestrator.sh
# CLI-based automatic session orchestration for agent harness
#
# Usage:
#   bash orchestrator.sh [--max-sessions N] [--max-hours H] [--dry-run]
#
# Reads state files, determines the next agent to invoke,
# and runs Claude Code sessions in headless mode.
# =========================================================

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

# --- Defaults ---
MAX_SESSIONS=20
MAX_HOURS=4
DRY_RUN=false
CONSECUTIVE_FAILURES=0
MAX_CONSECUTIVE_FAILURES=3
SESSION_COUNT=0
START_TIME=$(date +%s)

# --- Parse args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --max-sessions) MAX_SESSIONS="$2"; shift 2 ;;
    --max-hours) MAX_HOURS="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    --help)
      echo "Usage: bash orchestrator.sh [--max-sessions N] [--max-hours H] [--dry-run]"
      echo "  --max-sessions  Maximum sessions to run (default: 20)"
      echo "  --max-hours     Maximum hours to run (default: 4)"
      echo "  --dry-run       Show what would run without executing"
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

MAX_SECONDS=$((MAX_HOURS * 3600))

# --- Helper functions ---
log() {
  echo "[orchestrator] $(date +%H:%M:%S) $1"
}

elapsed_seconds() {
  echo $(( $(date +%s) - START_TIME ))
}

should_stop() {
  if [ "$SESSION_COUNT" -ge "$MAX_SESSIONS" ]; then
    log "최대 세션 수 도달 ($MAX_SESSIONS)"
    return 0
  fi
  if [ "$(elapsed_seconds)" -ge "$MAX_SECONDS" ]; then
    log "최대 실행 시간 도달 (${MAX_HOURS}h)"
    return 0
  fi
  if [ "$CONSECUTIVE_FAILURES" -ge "$MAX_CONSECUTIVE_FAILURES" ]; then
    log "연속 실패 $MAX_CONSECUTIVE_FAILURES회 — 중단"
    return 0
  fi
  return 1
}

get_smoke_status() {
  local report="$ROOT_DIR/state/smoke_report.json"
  if [ ! -f "$report" ]; then
    echo "unknown"
    return
  fi
  python3 -c "
import json
with open('$report') as f:
    print(json.load(f).get('result', 'unknown'))
" 2>/dev/null || echo "unknown"
}

get_contract_status() {
  local task="$ROOT_DIR/tasks/current_task.json"
  if [ ! -f "$task" ]; then
    echo "no_task"
    return
  fi
  python3 -c "
import json
with open('$task') as f:
    data = json.load(f)
cr = data.get('contract_review', {})
print(cr.get('contract_status', 'not_required'))
" 2>/dev/null || echo "unknown"
}

get_task_status() {
  local task="$ROOT_DIR/tasks/current_task.json"
  if [ ! -f "$task" ]; then
    echo "no_task"
    return
  fi
  python3 -c "
import json
with open('$task') as f:
    data = json.load(f)
print(data.get('status', data.get('task', {}).get('status', 'unknown')))
" 2>/dev/null || echo "unknown"
}

has_remaining_work() {
  python3 -c "
import json
with open('$ROOT_DIR/feature_list.json') as f:
    items = json.load(f)
remaining = [i for i in items if isinstance(i, dict) and 'id' in i and not i.get('passes', False)]
print('true' if remaining else 'false')
" 2>/dev/null || echo "false"
}

get_review_status() {
  local summary="$ROOT_DIR/state/session_summary.json"
  if [ ! -f "$summary" ]; then
    echo "unknown"
    return
  fi
  python3 -c "
import json
with open('$summary') as f:
    data = json.load(f)
print(data.get('review', {}).get('review_status', 'unknown'))
" 2>/dev/null || echo "unknown"
}

run_agent() {
  local agent="$1"
  local prompt="$2"
  
  SESSION_COUNT=$((SESSION_COUNT + 1))
  log "=== Session $SESSION_COUNT: $agent ==="
  
  if [ "$DRY_RUN" = "true" ]; then
    log "[DRY-RUN] claude -p \"$prompt\" --agent $agent --permission-mode auto --output-format json"
    return 0
  fi
  
  local output
  if output=$(claude -p "$prompt" \
    --agent "$agent" \
    --permission-mode auto \
    --output-format json \
    --max-turns 50 \
    2>&1); then
    log "$agent 세션 완료 (성공)"
    CONSECUTIVE_FAILURES=0
    return 0
  else
    log "$agent 세션 실패"
    CONSECUTIVE_FAILURES=$((CONSECUTIVE_FAILURES + 1))
    return 1
  fi
}

# --- Determine next action ---
determine_next_action() {
  local smoke_status
  smoke_status=$(get_smoke_status)
  
  # 1. smoke 실패 → recovery
  if [ "$smoke_status" = "failed" ]; then
    echo "recovery"
    return
  fi
  
  local task_status
  task_status=$(get_task_status)
  
  # 2. 작업 없음 → planner
  if [ "$task_status" = "no_task" ]; then
    if [ "$(has_remaining_work)" = "true" ]; then
      echo "planner"
    else
      echo "done"
    fi
    return
  fi
  
  local contract_status
  contract_status=$(get_contract_status)
  
  # 3. 계약 대기 → reviewer (contract)
  if [ "$contract_status" = "pending_review" ]; then
    echo "reviewer_contract"
    return
  fi
  
  # 4. 계약 반려 → planner (수정)
  if [ "$contract_status" = "rejected" ] || [ "$contract_status" = "revision_needed" ]; then
    echo "planner_revise"
    return
  fi
  
  # 5. 구현 대기 → coder
  if [ "$task_status" = "not_started" ] || [ "$task_status" = "in_progress" ]; then
    if [ "$contract_status" = "approved" ] || [ "$contract_status" = "not_required" ]; then
      echo "coder"
      return
    fi
  fi
  
  # 6. 구현 완료, 리뷰 대기 → reviewer
  if [ "$task_status" = "verified" ]; then
    echo "reviewer_impl"
    return
  fi
  
  # 7. 리뷰 반려 → coder (재작업)
  local review_status
  review_status=$(get_review_status)
  if [ "$task_status" = "rejected" ] || [ "$review_status" = "rejected" ]; then
    echo "coder_rework"
    return
  fi
  
  # 8. 작업 완료 → 다음 작업 선택
  if [ "$task_status" = "passed" ]; then
    echo "planner"
    return
  fi
  
  echo "unknown"
}

# --- Main loop ---
log "오케스트레이터 시작 (max_sessions=$MAX_SESSIONS, max_hours=$MAX_HOURS)"

while ! should_stop; do
  ACTION=$(determine_next_action)
  log "상태 판단: $ACTION"
  
  case "$ACTION" in
    recovery)
      run_agent "coder" "smoke 검증이 실패했습니다. scripts/collect_status.sh를 실행하여 상태를 확인하고, 원인을 진단하여 복구하세요. 복구 후 bash ./verification/smoke.sh를 실행하여 통과를 확인하세요." || true
      ;;
    planner)
      run_agent "planner" "feature_list.json을 읽고, 의존성이 충족된 미완료 작업 중 우선순위가 가장 높은 작업 1개를 선택하세요. tasks/current_task.json을 생성하고 contract_status를 pending_review로 설정하세요." || true
      ;;
    planner_revise)
      run_agent "planner" "tasks/current_task.json의 계약이 반려되었습니다. contract_review_notes를 읽고 범위/기준/검증계획을 수정한 뒤 contract_status를 pending_review로 재설정하세요." || true
      ;;
    reviewer_contract)
      run_agent "reviewer" "tasks/current_task.json의 계약을 검토하세요. 범위, 수용 기준, 검증 계획의 명확성과 실행 가능성을 평가하고 contract_status를 approved, rejected, 또는 revision_needed로 설정하세요." || true
      ;;
    coder)
      run_agent "coder" "tasks/current_task.json의 승인된 작업을 구현하세요. 범위 내에서만 작업하고, 완료 후 검증을 실행하세요. feature_list.json과 claude-progress.txt를 업데이트하세요." || true
      ;;
    coder_rework)
      run_agent "coder" "이전 구현이 반려되었습니다. state/session_summary.json의 반려 사유를 확인하고 수정하세요. 수정 후 검증을 실행하고 상태를 업데이트하세요." || true
      ;;
    reviewer_impl)
      run_agent "reviewer" "구현 결과를 검토하세요. 범위 준수, 검증 증거, 회귀 위험을 평가하고 승인 또는 반려를 결정하세요. state/session_summary.json을 업데이트하세요." || true
      ;;
    done)
      log "모든 작업 완료!"
      break
      ;;
    unknown)
      log "상태를 판단할 수 없습니다. 수동 확인이 필요합니다."
      break
      ;;
  esac
  
  # 짧은 대기 (API rate limit 고려)
  if [ "$DRY_RUN" = "false" ]; then
    sleep 5
  fi
done

# --- 최종 보고 ---
ELAPSED=$(elapsed_seconds)
ELAPSED_MIN=$((ELAPSED / 60))
log "=== 오케스트레이터 종료 ==="
log "총 세션: $SESSION_COUNT"
log "실행 시간: ${ELAPSED_MIN}분"
log "연속 실패: $CONSECUTIVE_FAILURES"
```

- [ ] **Step 2: 실행 권한 부여**

Run: `chmod +x orchestrator.sh`

- [ ] **Step 3: dry-run 테스트**

Run: `bash orchestrator.sh --dry-run --max-sessions 5`

Expected: 상태를 읽고 다음 행동을 결정하는 로그 출력, 실제 claude CLI 호출 없음

- [ ] **Step 4: 커밋**

```bash
git add orchestrator.sh
git commit -m "feat: add CLI-based orchestrator for automatic session cycling"
```

---

### Task 8: settings.json 통합 및 최종 검증

**Files:**
- Modify: `.claude/settings.json` (전체 통합)

- [ ] **Step 1: `.claude/settings.json` 최종 통합본 작성**

모든 hook을 하나의 settings.json에 통합:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "if": "Bash(rm -rf *)",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/block-dangerous-commands.sh",
            "timeout": 5
          }
        ]
      },
      {
        "matcher": "Bash",
        "if": "Bash(git push --force*)",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/block-dangerous-commands.sh",
            "timeout": 5
          }
        ]
      },
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/check-smoke-before-edit.sh",
            "timeout": 10
          }
        ]
      },
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/check-contract-before-edit.sh",
            "timeout": 10
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/post-edit-verify.sh",
            "timeout": 30,
            "async": true
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/stop-progress-gate.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 2: 모든 hook 스크립트 실행 권한 확인**

Run: `ls -la .claude/hooks/*.sh`

Expected: 모든 파일에 `x` 권한 존재

- [ ] **Step 3: 셸 문법 검증**

Run: `for f in .claude/hooks/*.sh orchestrator.sh; do echo "=== $f ===" && bash -n "$f" && echo "OK"; done`

Expected: 모든 파일 OK

- [ ] **Step 4: settings.json JSON 검증**

Run: `python3 -m json.tool .claude/settings.json > /dev/null && echo "Valid JSON"`

Expected: `Valid JSON`

- [ ] **Step 5: 최종 커밋**

```bash
git add .claude/settings.json .claude/hooks/ .claude/rules/ orchestrator.sh
git commit -m "feat: complete harness Claude Code integration (hooks, rules, orchestrator)"
```

---

## Verification Checklist

- [ ] `.claude/settings.json`이 valid JSON인지 확인
- [ ] 모든 `.claude/hooks/*.sh` 스크립트가 `bash -n`으로 문법 검증 통과
- [ ] 모든 hook 스크립트에 실행 권한(`chmod +x`) 있는지 확인
- [ ] `.claude/rules/` 아래 3개 규칙 파일이 YAML frontmatter를 포함하는지 확인
- [ ] `orchestrator.sh --dry-run`이 에러 없이 실행되는지 확인
- [ ] `orchestrator.sh --help`가 사용법을 출력하는지 확인
