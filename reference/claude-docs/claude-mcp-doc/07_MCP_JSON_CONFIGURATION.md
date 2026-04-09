# 07. JSON 설정 방식

## 1. add-json 사용
JSON 형태의 MCP 설정을 바로 등록할 수 있다.

```bash
claude mcp add-json weather-api '{"type":"http","url":"https://api.weather.com/mcp"}'
```

## 2. `.mcp.json` 기본 구조
```json
{
  "mcpServers": {
    "shared-server": {
      "command": "/path/to/server",
      "args": [],
      "env": {}
    }
  }
}
```

## 3. 환경 변수 확장
`.mcp.json`에서는 다음 문법을 지원한다.
- `${VAR}`
- `${VAR:-default}`

예:
```json
{
  "mcpServers": {
    "api-server": {
      "type": "http",
      "url": "${API_BASE_URL:-https://api.example.com}/mcp",
      "headers": {
        "Authorization": "Bearer ${API_KEY}"
      }
    }
  }
}
```

## 4. 실무 원칙
- 프로젝트 공유 설정은 `.mcp.json`에 둔다.
- 민감한 값은 환경 변수로 분리한다.
- 누락된 필수 환경 변수가 있으면 파싱이 실패할 수 있다.
