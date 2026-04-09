# Claude Code CLI Quick Cheatsheet

## Interactive
- `claude`
- `claude "explain this project"`

## Headless
- `claude -p "summarize this file"`
- `cat logs.txt | claude -p "explain"`

## Resume
- `claude -c`
- `claude -r auth-refactor`
- `claude --resume auth-refactor --fork-session`

## Safety
- `claude --permission-mode plan`
- `claude --enable-auto-mode`

## Output
- `claude -p "query" --output-format json`
- `claude -p "query" --json-schema '{"type":"object"}'`

## Isolation
- `claude -w feature-auth`

## Debug
- `claude --debug "api,hooks"`
