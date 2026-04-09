# 인증 및 Provider 라우팅 변수
문서 ID: CC-ENV-AUTH
버전: v1.0.0

## 1. 핵심 인증 변수
### 1.1 ANTHROPIC_API_KEY
- X-Api-Key 헤더에 사용되는 API key
- 설정 시 Claude 구독보다 이 키가 우선 사용될 수 있음
- `-p` 비대화형 모드에서는 항상 키 사용

### 1.2 ANTHROPIC_AUTH_TOKEN
- Authorization 헤더의 Bearer 토큰 값

### 1.3 ANTHROPIC_BASE_URL
- API endpoint override
- 프록시/게이트웨이/LLM gateway 경유 시 사용
- non-first-party host이면 MCP tool search가 기본 비활성

### 1.4 ANTHROPIC_BETAS / ANTHROPIC_CUSTOM_HEADERS
- beta header 추가
- custom request header 주입

## 2. Bedrock 관련
- CLAUDE_CODE_USE_BEDROCK
- ANTHROPIC_BEDROCK_BASE_URL
- ANTHROPIC_BEDROCK_MANTLE_BASE_URL
- AWS_BEARER_TOKEN_BEDROCK
- CLAUDE_CODE_SKIP_BEDROCK_AUTH
- CLAUDE_CODE_USE_MANTLE
- CLAUDE_CODE_SKIP_MANTLE_AUTH

## 3. Vertex 관련
- CLAUDE_CODE_USE_VERTEX
- ANTHROPIC_VERTEX_BASE_URL
- ANTHROPIC_VERTEX_PROJECT_ID
- CLAUDE_CODE_SKIP_VERTEX_AUTH
- VERTEX_REGION_* family

## 4. Microsoft Foundry 관련
- CLAUDE_CODE_USE_FOUNDRY
- ANTHROPIC_FOUNDRY_API_KEY
- ANTHROPIC_FOUNDRY_BASE_URL
- ANTHROPIC_FOUNDRY_RESOURCE
- CLAUDE_CODE_SKIP_FOUNDRY_AUTH

## 5. 운영 메모
- provider mode를 켜면 해당 provider 인증이 우선 경로가 된다
- gateway 환경에서는 skip auth 변수와 base URL override를 함께 고려
- credentials는 project 설정이 아니라 shell secret store 또는 user env에 두는 것이 안전
