# 모델 / 추론 / 컨텍스트 변수
문서 ID: CC-ENV-MODEL-CONTEXT
버전: v1.0.0

## 1. 모델 선택
- ANTHROPIC_MODEL
- ANTHROPIC_DEFAULT_HAIKU_MODEL
- ANTHROPIC_DEFAULT_SONNET_MODEL
- ANTHROPIC_DEFAULT_OPUS_MODEL
- ANTHROPIC_CUSTOM_MODEL_OPTION (+ NAME / DESCRIPTION)

## 2. 추론 깊이
### 2.1 CLAUDE_CODE_EFFORT_LEVEL
- low / medium / high / max / auto
- `/effort`보다 우선

### 2.2 MAX_THINKING_TOKENS
- thinking budget override
- adaptive reasoning 모델에서는 무시될 수 있음

### 2.3 CLAUDE_CODE_DISABLE_THINKING
- extended thinking 강제 비활성화

### 2.4 CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING
- Opus 4.6 / Sonnet 4.6 adaptive reasoning 비활성화

## 3. 컨텍스트 압축
- CLAUDE_AUTOCOMPACT_PCT_OVERRIDE
- CLAUDE_CODE_AUTO_COMPACT_WINDOW
- DISABLE_AUTO_COMPACT
- DISABLE_COMPACT

## 4. 메모리 및 지침 로딩
- CLAUDE_CODE_DISABLE_AUTO_MEMORY
- CLAUDE_CODE_DISABLE_CLAUDE_MDS
- CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD

## 5. 출력 길이와 컨텍스트 경쟁
- CLAUDE_CODE_MAX_OUTPUT_TOKENS
- CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS
- MAX_MCP_OUTPUT_TOKENS
- 출력 토큰을 늘리면 compaction 시점이 앞당겨질 수 있음

## 6. 운영 메모
- 긴 세션에서 auto memory/CLAUDE.md 영향이 크면 disable 변수로 분리 진단
- reasoning 정책은 model/provider 조합과 함께 검증
