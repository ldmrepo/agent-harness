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

  # 8. 작업 blocked → planner에게 다른 작업 선택 요청
  if [ "$task_status" = "blocked" ]; then
    echo "planner_blocked"
    return
  fi

  # 9. 작업 완료 → 다음 작업 선택
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
    planner_blocked)
      run_agent "planner" "현재 작업이 blocked 상태입니다. known_issues.json과 current_task.json의 blocked_reason을 확인하세요. 블로커를 해결할 수 없으면 다른 작업을 선택하세요." || true
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
