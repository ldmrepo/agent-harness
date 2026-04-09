# Claude Code Extension Layer 문서 세트
문서 ID: CC-EXT-INDEX
버전: v1.0.0
기준일: 2026-04-08

## 목적
본 문서 세트는 Claude Code의 확장 계층을 구성하는 CLAUDE.md, Rules, Skills, MCP, Subagents, Agent teams, Hooks, Plugins, Marketplaces의 개념, 차이점, 선택 기준, 우선순위, 컨텍스트 비용, 조합 패턴을 표준 문서 형식으로 정리한다.

## 범위
- 확장 계층의 개념 정의
- 기능별 역할과 선택 기준
- 유사 기능 비교
- 레이어링/우선순위 규칙
- 컨텍스트 비용과 로딩 방식
- 조합 패턴
- 운영 원칙 및 트러블슈팅

## 문서 목록
1. 01_EXTENSIONS_OVERVIEW.md
2. 02_EXTENSION_FEATURE_MATRIX.md
3. 03_COMPARE_SIMILAR_FEATURES.md
4. 04_LAYERING_AND_PRECEDENCE.md
5. 05_CONTEXT_COSTS_AND_LOADING.md
6. 06_CLAUDE_MD_AND_RULES.md
7. 07_SKILLS_AND_SUBAGENTS.md
8. 08_MCP_HOOKS_PLUGINS_AND_MARKETPLACES.md
9. 09_EXTENSION_PATTERNS_AND_RECIPES.md
10. 10_EXTENSION_OPERATIONS_AND_TROUBLESHOOTING.md

## 읽기 순서
- 처음 읽는 경우: 01 → 02 → 03 → 05
- 프로젝트 표준 설계: 02 → 04 → 06 → 07 → 08
- 운영/비용 관점: 04 → 05 → 10
- 실전 구성 예시: 09