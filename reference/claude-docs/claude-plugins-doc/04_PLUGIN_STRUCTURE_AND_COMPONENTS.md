# 04. Plugin 구조와 컴포넌트

문서 버전: v1.0.0

## 1. 표준 구조
```text
my-plugin/
├── .claude-plugin/
│   └── plugin.json
├── commands/
├── agents/
├── skills/
├── hooks/
├── bin/
├── settings.json
├── .mcp.json
└── .lsp.json
```

## 2. 가장 중요한 규칙
`.claude-plugin/` 안에는 보통 `plugin.json`만 둔다.  
`commands/`, `agents/`, `skills/`, `hooks/` 등은 모두 플러그인 루트에 있어야 한다.

## 3. 컴포넌트별 역할
### 3.1 skills/
Agent Skills를 제공한다. 일반적으로 `skills/<skill-name>/SKILL.md` 구조를 사용한다.

### 3.2 commands/
레거시 command markdown 위치다. 새 skill은 `skills/` 사용이 권장된다.

### 3.3 agents/
커스텀 subagent 정의 파일을 둔다. `/agents`에 나타나며 Claude가 자동 선택할 수 있다.

### 3.4 hooks/
`hooks/hooks.json`로 이벤트 기반 자동화를 제공한다.

### 3.5 .mcp.json
플러그인 전용 MCP 서버를 묶는다.

### 3.6 .lsp.json
코드 인텔리전스를 위한 LSP 서버 구성을 제공한다.

### 3.7 bin/
여기에 둔 실행 파일은 플러그인이 활성화된 동안 Bash tool의 PATH에 추가된다.

### 3.8 settings.json
플러그인이 활성화될 때 기본 설정을 제공한다. 현재 공식 문서 기준으로 `agent` 키 지원이 핵심이다.

## 4. 고급 구조 예시
```text
enterprise-plugin/
├── .claude-plugin/plugin.json
├── agents/
├── skills/
├── output-styles/
├── hooks/hooks.json
├── bin/
├── settings.json
├── .mcp.json
├── .lsp.json
└── scripts/
```

## 5. 설계 원칙
- skills는 도메인 지식과 반복 작업
- agents는 전문 역할과 작업 격리
- hooks는 결정적 자동화
- MCP는 외부 시스템 연동
- LSP는 언어 인텔리전스
- plugin은 이들을 하나의 제품처럼 묶는 계층
