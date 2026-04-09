#!/usr/bin/env bash
set -euo pipefail

# =========================================================
# configure.sh
# Template variable substitution tool for agent harness
#
# Usage:
#   bash configure.sh --config variables.json
#   bash configure.sh --config variables.json --dry-run
#   bash configure.sh --interactive
#   bash configure.sh --generate-example
#   bash configure.sh --help
#
# Requires: python3 (already a harness dependency)
# =========================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Argument parsing (bash-3.2 compatible) ------------------------------

CONFIG_FILE=""
INTERACTIVE=false
DRY_RUN=false
GENERATE_EXAMPLE=false

usage() {
    cat <<'HELP'
Usage: bash configure.sh [OPTIONS]

Substitute {{VARIABLE}} placeholders across the agent harness template.

Options:
  --config <file>       Read variables from a JSON file
  --interactive         Prompt for each required variable interactively
  --dry-run             Show what would change without modifying files
  --generate-example    Write project_variables.example.json and exit
  --help                Show this help message

Examples:
  bash configure.sh --interactive
  bash configure.sh --config project_variables.json
  bash configure.sh --config project_variables.json --dry-run
HELP
}

if [ $# -eq 0 ]; then usage; exit 1; fi

while [ $# -gt 0 ]; do
    case "$1" in
        --config)
            [ -n "${2:-}" ] || { echo "ERROR: --config requires a file path" >&2; exit 1; }
            CONFIG_FILE="$2"; shift 2 ;;
        --interactive)  INTERACTIVE=true; shift ;;
        --dry-run)      DRY_RUN=true; shift ;;
        --generate-example) GENERATE_EXAMPLE=true; shift ;;
        --help|-h)      usage; exit 0 ;;
        *)              echo "ERROR: Unknown option: $1" >&2; exit 1 ;;
    esac
done

# --- Delegate to Python for all data-intensive work ----------------------
# Python handles: variable definitions, interactive prompts, JSON I/O,
# file scanning, sed substitution, and reporting.

exec python3 - "$SCRIPT_DIR" "$CONFIG_FILE" "$INTERACTIVE" "$DRY_RUN" "$GENERATE_EXAMPLE" <<'PYTHON_SCRIPT'
import sys, os, json, re, collections, glob

script_dir    = sys.argv[1]
config_file   = sys.argv[2]
interactive   = sys.argv[3] == "true"
dry_run       = sys.argv[4] == "true"
gen_example   = sys.argv[5] == "true"

OUTPUT_JSON   = "project_variables.json"
SCRIPT_NAME   = "configure.sh"

# ── Minimum required variables ──────────────────────────────────────────

Variable = collections.namedtuple("Variable", ["name", "default", "desc", "section"])

REQUIRED_VARS = [
    # Identity
    Variable("PROJECT_NAME",                "my-project",                     "Project display name",                       "Identity"),
    Variable("REPOSITORY_NAME",             "",                               "Repository root directory name",             "Identity"),
    Variable("HARNESS_TEMPLATE_VERSION",    "v1.0",                           "Template version identifier",                "Identity"),
    Variable("DEFAULT_BRANCH",              "main",                           "Default git branch",                         "Identity"),
    # Runtime
    Variable("RUNTIME_TYPE",                "fullstack",                      "Runtime type (api/webapp/worker/fullstack)",  "Runtime"),
    Variable("PRIMARY_STACK",               "",                               "Main tech stack description",                "Runtime"),
    Variable("PACKAGE_MANAGER",             "pnpm",                           "Package manager (pnpm/npm/yarn/poetry/uv)",  "Runtime"),
    # Paths
    Variable("APP_DIR_NAME",                "app",                            "Application code directory",                 "Paths"),
    Variable("STATE_DIR_NAME",              "state",                          "State files directory",                      "Paths"),
    Variable("LOG_DIR_NAME",                ".agent-logs",                    "Log directory",                              "Paths"),
    Variable("PID_DIR_NAME",                ".agent-pids",                    "PID files directory",                        "Paths"),
    # Commands
    Variable("CMD_BOOTSTRAP",               "bash ./init.sh",                 "Bootstrap command",                          "Commands"),
    Variable("CMD_INSTALL",                 "",                               "Install dependencies command",               "Commands"),
    Variable("CMD_DEV",                     "",                               "Start app for development",                  "Commands"),
    Variable("CMD_SMOKE",                   "bash ./verification/smoke.sh",   "Smoke verification command",                 "Commands"),
    Variable("CMD_VERIFY_ALL",              "bash ./verification/verify_all.sh", "Full verification command",               "Commands"),
    # Network
    Variable("HEALTHCHECK_URL",             "",                               "Health check endpoint URL",                  "Network"),
    Variable("APP_PORT",                    "3000",                           "Application port",                           "Network"),
    Variable("API_PORT",                    "8000",                           "API port",                                   "Network"),
    # Policy
    Variable("ALLOW_PARALLEL_TASKS",        "false",                          "Allow multiple tasks per session",           "Policy"),
    Variable("REQUIRE_REVIEW_AGENT",        "true",                           "Require reviewer approval",                  "Policy"),
    Variable("REQUIRE_CONTRACT_REVIEW",     "true",                           "Require contract review before coding",      "Policy"),
    Variable("REQUIRE_FULL_VERIFY_FOR_CORE_CHANGE", "true",                   "Full verify for core changes",               "Policy"),
    Variable("ALLOW_AUTO_COMMIT",           "false",                          "Auto commit at session end",                 "Policy"),
    Variable("SESSION_MAX_SCOPE",           "single bounded task",            "Max session scope description",              "Policy"),
    # Bootstrap Flags
    Variable("BOOTSTRAP_ENABLE_INSTALL",    "true",                           "Enable dependency install on bootstrap",     "Bootstrap Flags"),
    Variable("BOOTSTRAP_ENABLE_APP_START",  "true",                           "Enable app startup on bootstrap",            "Bootstrap Flags"),
    Variable("BOOTSTRAP_ENABLE_HEALTHCHECK","true",                           "Enable health check on bootstrap",           "Bootstrap Flags"),
    # Strategic Planning
    Variable("STRATEGIST_AGENT_MODEL",      "opus",                           "Model for strategist agent",                 "Strategic Planning"),
    Variable("STRATEGIST_AGENT_COLOR",      "magenta",                        "Color for strategist agent",                 "Strategic Planning"),
    Variable("ENABLE_STRATEGIST_PHASE",     "true",                           "Enable strategist for project planning",     "Strategic Planning"),
    Variable("MAX_FEATURES_PER_MILESTONE",  "10",                             "Max feature items per milestone",            "Strategic Planning"),
    Variable("ROADMAP_SCHEMA_VERSION",      "1.0",                            "Roadmap JSON schema version",                "Strategic Planning"),
    Variable("STRATEGIC_REVIEW_SCHEMA_VERSION", "1.0",                        "Strategic review JSON schema version",        "Strategic Planning"),
    Variable("PROJECT_GOAL_DESCRIPTION",    "",                               "Project goal description",                   "Strategic Planning"),
    Variable("PROJECT_TARGET_USERS",        "",                               "Target users",                               "Strategic Planning"),
    Variable("PROJECT_KEY_CAPABILITIES",    "",                               "Key capabilities",                           "Strategic Planning"),
    Variable("PROJECT_CONSTRAINTS",         "",                               "Technical constraints",                      "Strategic Planning"),
    Variable("PROJECT_SUCCESS_CRITERIA",    "",                               "Success criteria",                           "Strategic Planning"),
    Variable("PROJECT_NOTES",              "",                               "Additional project notes",                   "Strategic Planning"),
]

# ── Generate example config ─────────────────────────────────────────────

if gen_example:
    data = collections.OrderedDict()
    data["_comments"] = {v.name: v.desc for v in REQUIRED_VARS}
    for v in REQUIRED_VARS:
        data[v.name] = v.default
    path = os.path.join(script_dir, "project_variables.example.json")
    with open(path, "w") as f:
        json.dump(data, f, indent=2)
        f.write("\n")
    print(f"Generated {path}")
    print("Edit the values, remove the _comments key if desired, then run:")
    print("  bash configure.sh --config project_variables.example.json")
    sys.exit(0)

# ── Collect variables ────────────────────────────────────────────────────

variables = collections.OrderedDict()

if interactive:
    print()
    print("=== Agent Harness Configuration ===")
    print()
    print("This tool will substitute {{VARIABLE}} placeholders in all template files.")
    print("Make sure you have committed or backed up your current state.")
    print()

    current_section = ""
    for v in REQUIRED_VARS:
        if v.section != current_section:
            print(f"--- {v.section} ---")
            current_section = v.section

        if v.default:
            prompt = f"  {v.name} ({v.desc}) [{v.default}]: "
        else:
            prompt = f"  {v.name} ({v.desc}): "

        try:
            value = input(prompt).strip()
        except (EOFError, KeyboardInterrupt):
            print("\nAborted.")
            sys.exit(1)

        variables[v.name] = value if value else v.default

    # Auto-fill REPOSITORY_NAME from PROJECT_NAME if blank
    if not variables.get("REPOSITORY_NAME"):
        variables["REPOSITORY_NAME"] = variables.get("PROJECT_NAME", "")

    # Save for future use
    out_path = os.path.join(script_dir, OUTPUT_JSON)
    with open(out_path, "w") as f:
        json.dump(variables, f, indent=2)
        f.write("\n")
    print()
    print(f"Saved configuration to {OUTPUT_JSON}")
    print()

elif config_file:
    if not os.path.isfile(config_file):
        # Try relative to script dir
        alt = os.path.join(script_dir, config_file)
        if os.path.isfile(alt):
            config_file = alt
        else:
            print(f"ERROR: Config file not found: {config_file}", file=sys.stderr)
            sys.exit(1)

    with open(config_file) as f:
        data = json.load(f)

    for k, v in data.items():
        if k == "_comments":
            continue
        # Normalize booleans to lowercase strings
        if isinstance(v, bool):
            variables[k] = "true" if v else "false"
        else:
            variables[k] = str(v)

    print(f"Loaded {len(variables)} variable(s) from {config_file}")
else:
    print("ERROR: Specify --config <file> or --interactive", file=sys.stderr)
    sys.exit(1)

if not variables:
    print("ERROR: No variables loaded.", file=sys.stderr)
    sys.exit(1)

# ── Find target files ────────────────────────────────────────────────────

SKIP_DIRS  = {".git", "node_modules", ".venv", "__pycache__", ".next", "dist", "build"}
SKIP_FILES = {SCRIPT_NAME, OUTPUT_JSON, "project_variables.example.json"}
EXTENSIONS = {".md", ".sh", ".json", ".txt"}

target_files = []
for root, dirs, files in os.walk(script_dir):
    # Prune skipped directories
    dirs[:] = [d for d in dirs if d not in SKIP_DIRS]
    for fname in files:
        if fname in SKIP_FILES:
            continue
        _, ext = os.path.splitext(fname)
        if ext in EXTENSIONS:
            target_files.append(os.path.join(root, fname))

target_files.sort()
print(f"Scanning {len(target_files)} file(s) for {{{{VARIABLE}}}} placeholders...")
print()

if dry_run:
    print("[DRY RUN] No files will be modified.")
    print()

# ── Substitution ─────────────────────────────────────────────────────────

total_vars_applied = 0
total_occurrences  = 0
modified_files     = set()

for var_name, value in variables.items():
    pattern = "{{" + var_name + "}}"
    var_count = 0
    var_files = 0

    for fpath in target_files:
        try:
            with open(fpath, "r") as f:
                content = f.read()
        except (UnicodeDecodeError, PermissionError):
            continue

        count = content.count(pattern)
        if count == 0:
            continue

        var_count += count
        var_files += 1

        if not dry_run:
            new_content = content.replace(pattern, value)
            with open(fpath, "w") as f:
                f.write(new_content)
            modified_files.add(fpath)

    if var_count > 0:
        total_vars_applied += 1
        total_occurrences += var_count
        prefix = "[DRY RUN] Would replace" if dry_run else "Replaced"
        print(f"  {prefix} {{{{{var_name}}}}} in {var_files} file(s) ({var_count} occurrence(s))")

# ── Remaining placeholders ───────────────────────────────────────────────

print()
print("--- Post-substitution report ---")
print()

remaining = collections.Counter()
pattern_re = re.compile(r"\{\{[A-Z][A-Z0-9_]*\}\}")

for fpath in target_files:
    try:
        with open(fpath, "r") as f:
            content = f.read()
    except (UnicodeDecodeError, PermissionError):
        continue
    for match in pattern_re.findall(content):
        remaining[match] += 1

if remaining:
    print("Remaining placeholders (not substituted):")
    for placeholder, count in sorted(remaining.items()):
        print(f"  {placeholder}  ({count} occurrence(s))")
    print()

# ── Summary ──────────────────────────────────────────────────────────────

action = "would apply" if dry_run else "applied"
mod_count = len(modified_files)
rem_count = len(remaining)

print(f"Summary: {total_vars_applied} variable(s) {action}, "
      f"{mod_count} file(s) modified, "
      f"{total_occurrences} total substitution(s).")
if rem_count > 0:
    print(f"{rem_count} unique placeholder(s) remaining.")
    print("Use --config with additional variables to fill them.")
print()

if dry_run:
    print("Re-run without --dry-run to apply changes.")
PYTHON_SCRIPT
