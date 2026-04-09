#!/usr/bin/env bash
# =========================================================
# scripts/_common.sh
# Shared utility functions for long-running agent harness scripts
# Template Version: {{HARNESS_TEMPLATE_VERSION}}
# Project Name: {{PROJECT_NAME}}
#
# This file is sourced by other scripts in the harness.
# Do not execute directly.
# =========================================================

# log <message>
#   Write message to stdout and append to the current log file.
#   Requires: LOG_FILE variable must be set by the calling script.
# Parameters:
#   $1 - message string to log
# Returns: 0
log() {
  local msg="$1"
  echo "$msg"
  if [ -n "${LOG_FILE:-}" ]; then
    echo "$msg" >> "$LOG_FILE"
  fi
}

# json_escape <string>
#   Escape a string for safe inclusion in JSON.
#   Outputs a JSON-encoded string WITH surrounding quotes.
#   Requires: python3 available on PATH.
# Parameters:
#   $1 - raw string to escape
# Returns: 0, outputs JSON-safe quoted string to stdout
json_escape() {
  printf '%s' "$1" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}

# command_exists <command_name>
#   Check if a command is available on the system.
# Parameters:
#   $1 - command name to check
# Returns: 0 if command exists, 1 otherwise
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# run_check <check_name> <command>
#   Execute a verification command and log the result.
#   Used by smoke.sh and verify_all.sh for running checks.
# Parameters:
#   $1 - descriptive name for the check
#   $2 - shell command to execute
# Returns: 0 if command succeeds, 1 if it fails
run_check() {
  local check_name="$1"
  local cmd="$2"

  echo "[check] check=$check_name"
  if bash -lc "$cmd"; then
    echo "[check] PASS: $check_name"
    return 0
  else
    echo "[check] FAIL: $check_name"
    return 1
  fi
}

# append_result <name> <result> <detail> <report_file>
#   Append a JSON check result entry to a report file.
#   Uses json_escape for safe JSON output.
# Parameters:
#   $1 - check name
#   $2 - result string (e.g., "passed", "failed", "skipped")
#   $3 - detail string (command or description)
#   $4 - path to the report file to append to
# Returns: 0
append_result() {
  local name="$1"
  local result="$2"
  local detail="$3"
  local report_file="$4"

  cat >> "$report_file" <<EOF
  {
    "name": $(json_escape "$name"),
    "result": "$result",
    "detail": $(json_escape "$detail")
  },
EOF
}

# run_or_warn <description> <command>
#   Execute a command with logging; warn on failure but don't exit.
# Parameters:
#   $1 - human-readable description of the step
#   $2 - shell command to execute
# Returns: 0 on success, 1 on failure
run_or_warn() {
  local description="$1"
  local cmd="$2"

  echo "[init] $description"
  if ! bash -lc "$cmd"; then
    echo "[init][warn] failed: $cmd"
    return 1
  fi
  return 0
}
