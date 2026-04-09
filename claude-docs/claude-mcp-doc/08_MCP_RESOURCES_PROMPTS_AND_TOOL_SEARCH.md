# 08. 리소스, 프롬프트, Tool Search

## 1. MCP 리소스
MCP 서버가 제공하는 리소스는 `@` 참조로 불러올 수 있다.

예:
```text
@github:issue://123
@docs:file://api/authentication
```

## 2. MCP 프롬프트
MCP 서버 프롬프트는 `/mcp__servername__promptname` 형식의 명령처럼 사용할 수 있다.

예:
```text
/mcp__github__list_prs
/mcp__github__pr_review 456
```

## 3. Tool Search
Tool Search는 MCP 도구 정의를 모두 미리 올리지 않고, 필요할 때만 탐색해 컨텍스트 사용량을 줄인다.

## 4. ENABLE_TOOL_SEARCH 값
- unset: 기본 지연 로드
- true: 항상 지연 로드
- auto / auto:N: 컨텍스트 임계치 기반
- false: 전부 upfront 로드

## 5. 실무 권장
MCP 서버 수가 많거나 각 도구 설명이 길면 Tool Search를 유지하는 것이 유리하다.
