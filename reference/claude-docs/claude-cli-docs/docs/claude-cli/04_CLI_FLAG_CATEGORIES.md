# CLI Flag 카테고리 분류
문서 ID: CC-CLI-FLAG-CATEGORIES
버전: v1.0.0

## 1. 분류 원칙
플래그는 무엇을 제어하느냐를 기준으로 분류한다.

## 2. 세션 제어 플래그
- `--continue`, `-c`
- `--resume`, `-r`
- `--fork-session`
- `--session-id`
- `--name`, `-n`
- `--no-session-persistence`

## 3. 권한/안전 제어 플래그
- `--permission-mode`
- `--enable-auto-mode`
- `--dangerously-skip-permissions`
- `--allow-dangerously-skip-permissions`
- `--permission-prompt-tool`

## 4. 도구/실행 범위 제어 플래그
- `--tools`
- `--allowedTools`
- `--disallowedTools`
- `--add-dir`
- `--strict-mcp-config`

## 5. 모델/추론/출력 제어 플래그
- `--model`
- `--effort`
- `--fallback-model`
- `--output-format`
- `--input-format`
- `--json-schema`
- `--max-turns`
- `--max-budget-usd`

## 6. 시스템 프롬프트 제어 플래그
- `--system-prompt`
- `--system-prompt-file`
- `--append-system-prompt`
- `--append-system-prompt-file`

## 7. 확장/통합 제어 플래그
- `--mcp-config`
- `--plugin-dir`
- `--agent`
- `--agents`
- `--chrome`
- `--ide`
- `--disable-slash-commands`

## 8. 원격/병렬 실행 플래그
- `--remote`
- `--teleport`
- `--remote-control`
- `--remote-control-session-name-prefix`
- `--worktree`, `-w`
- `--tmux`
- `--teammate-mode`

## 9. 디버깅/운영 플래그
- `--debug`
- `--debug-file`
- `--verbose`
- `--version`
- `--settings`
- `--setting-sources`
