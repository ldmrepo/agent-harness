# MCP, Web, 확장 관련 도구
문서 ID: CC-TOOLS-MCP-WEB
버전: v1.0.0

## 1. MCP 관련 도구
### ListMcpResourcesTool
연결된 MCP 서버가 노출한 리소스 목록 조회

### ReadMcpResourceTool
특정 MCP resource URI 읽기

### ToolSearch
지연 로드된 도구를 검색하고 로드

## 2. MCP 도구 확장 모델
새 도구를 추가하려면 MCP server를 연결한다.
내장 도구를 늘리는 표준 확장 지점은 MCP다.

## 3. Skill과 도구의 관계
skill은 새 도구가 아니다.
Skill 도구를 통해 prompt-based workflow를 실행한다.

## 4. Web 도구와의 관계
WebFetch와 WebSearch는 내장 네트워크 접근 도구다.
MCP는 외부 서비스 통합 계층이고, Web 도구는 일반 웹 접근 계층이다.
