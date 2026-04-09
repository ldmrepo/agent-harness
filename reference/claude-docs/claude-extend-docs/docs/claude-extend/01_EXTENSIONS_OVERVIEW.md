# Extend Claude Code 개요
문서 ID: CC-EXT-OVERVIEW
버전: v1.0.0

## 1. 정의
Claude Code의 확장 계층은 기본 내장 도구만으로 해결되지 않는 요구를 위해 Claude가 항상 알아야 할 것, 필요 시 불러올 것, 외부 서비스 연결, 격리 실행, 자동화를 추가하는 기능 묶음이다.

## 2. 확장 계층을 구성하는 기능
- CLAUDE.md
- Rules (`.claude/rules/`)
- Skills
- Subagents
- Agent teams
- MCP
- Hooks
- Plugins
- Marketplaces

## 3. 핵심 관점
확장 계층은 모두 같은 역할을 하지 않는다.
- 항상 켜진 컨텍스트: CLAUDE.md, 일부 Rules
- 온디맨드 지식/워크플로우: Skills
- 격리된 작업자: Subagents
- 독립 세션 협업: Agent teams
- 외부 서비스 연결: MCP
- 결정론적 자동화: Hooks
- 배포/공유 단위: Plugins, Marketplaces

## 4. 설계 원칙
- 항상 필요한 내용만 항상 로드한다.
- 자주 쓰지만 항상 필요하지 않은 내용은 온디맨드로 분리한다.
- 외부 시스템 접근은 MCP로 분리한다.
- 긴 탐색/병렬 작업은 Subagent 또는 Agent team으로 격리한다.
- 결정론적 검증은 Hook으로 구현한다.
- 재사용/배포가 필요하면 Plugin으로 패키징한다.