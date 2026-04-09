# 09. Plugin 및 Claude.ai 연동

## 1. 플러그인 제공 MCP 서버
플러그인은 자체 `.mcp.json` 또는 `plugin.json` 인라인 정의로 MCP 서버를 번들링할 수 있다.

장점:
- 설치와 동시에 도구 세트 배포
- 팀 표준화 쉬움
- 플러그인 루트/데이터 디렉터리 변수 사용 가능

## 2. Claude.ai 커넥터 연동
Claude.ai 계정으로 로그인된 Claude Code는 Claude.ai에서 추가한 MCP 서버를 자동으로 사용할 수 있다.

관리 방식:
- Claude.ai에서 커넥터 구성
- Claude Code에서 `/mcp`로 확인
- 필요 시 `ENABLE_CLAUDEAI_MCP_SERVERS=false`로 비활성화

## 3. Claude Code를 MCP 서버로 사용
Claude Code 자신을 다른 클라이언트가 붙는 MCP 서버로 실행할 수도 있다.

```bash
claude mcp serve
```

## 4. 적용 시나리오
- 사내 표준 플러그인 배포
- Claude.ai 기반 중앙 커넥터 운영
- Claude Desktop에서 Claude Code 도구 재사용
