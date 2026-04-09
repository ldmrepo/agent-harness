# Environment Variables 패턴 및 레시피
문서 ID: CC-ENV-RECIPES
버전: v1.0.0

## 1. API key + 높은 추론 깊이
```bash
export ANTHROPIC_API_KEY=...
export CLAUDE_CODE_EFFORT_LEVEL=high
claude
```

## 2. 사내 gateway 경유
```bash
export ANTHROPIC_BASE_URL=https://llm-gateway.example.com
export ENABLE_TOOL_SEARCH=true
claude
```

## 3. 긴 테스트/빌드에 맞춘 runtime
```bash
export BASH_DEFAULT_TIMEOUT_MS=300000
export BASH_MAX_TIMEOUT_MS=900000
export API_TIMEOUT_MS=900000
claude
```

## 4. 최소 모드 헤드리스 실행
```bash
export CLAUDE_CODE_SIMPLE=1
claude -p "summarize this repository"
```

## 5. context 압축 조기 실행
```bash
export CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=50
claude
```

## 6. auto memory 분리 진단
```bash
export CLAUDE_CODE_DISABLE_AUTO_MEMORY=1
claude
```

## 7. 프록시 + watchdog
```bash
export HTTPS_PROXY=https://proxy.example.com:8443
export CLAUDE_ENABLE_STREAM_WATCHDOG=1
export CLAUDE_STREAM_IDLE_TIMEOUT_MS=120000
claude
```

## 8. plugin 동기 설치가 필요한 -p 파이프라인
```bash
export CLAUDE_CODE_SYNC_PLUGIN_INSTALL=1
export CLAUDE_CODE_SYNC_PLUGIN_INSTALL_TIMEOUT_MS=30000
claude -p "run the plugin-enabled task"
```
