# 자동화, Headless, Streaming
문서 ID: CC-CLI-AUTOMATION
버전: v1.0.0

## 1. print mode의 역할
`-p`는 대화형 세션 없이 Claude Code를 자동화 구성요소처럼 사용하게 한다.

## 2. 대표 패턴
### 2.1 단일 질의
`claude -p "query"`

### 2.2 파이프 입력
`cat logs.txt | claude -p "explain"`

### 2.3 JSON 출력
`claude -p "query" --output-format json`

### 2.4 stream-json 출력
`claude -p "query" --output-format stream-json`

## 3. 고급 자동화 옵션
- `--include-hook-events`
- `--include-partial-messages`
- `--replay-user-messages`
- `--no-session-persistence`

## 4. bare mode
### 4.1 `--bare`
- hooks, skills, plugins, MCP, auto memory, CLAUDE.md 자동 발견 비활성화
- Bash, file read, file edit 중심 최소 모드

## 5. 입력/출력 제어 원칙
- 간단 통합: text
- 파이프라인 연동: json
- 실시간 처리: stream-json
- 구조화 계약: json-schema
