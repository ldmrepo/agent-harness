# 03. MCP 설치 방식

## 1. HTTP 서버 추가
가장 권장되는 원격 MCP 연결 방식이다.

```bash
claude mcp add --transport http <name> <url>
```

예:
```bash
claude mcp add --transport http notion https://mcp.notion.com/mcp
```

헤더 포함 예:
```bash
claude mcp add --transport http secure-api https://api.example.com/mcp \
  --header "Authorization: Bearer your-token"
```

## 2. SSE 서버 추가
레거시 방식이며 가능하면 HTTP로 대체한다.

```bash
claude mcp add --transport sse <name> <url>
```

## 3. stdio 서버 추가
로컬 프로세스를 직접 실행하는 방식이다.

```bash
claude mcp add --transport stdio --env KEY=value <name> -- <command> [args...]
```

예:
```bash
claude mcp add --transport stdio --env AIRTABLE_API_KEY=YOUR_KEY airtable \
  -- npx -y airtable-mcp-server
```

## 4. 옵션 배치 규칙
- `--transport`, `--env`, `--scope`, `--header`는 서버 이름 앞에 둔다.
- `--` 뒤는 MCP 서버 프로세스에 전달되는 실제 명령과 인자다.

## 5. Windows 주의사항
네이티브 Windows에서 `npx` 기반 stdio 서버는 보통 `cmd /c` 래퍼가 필요하다.
