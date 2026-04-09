# Extend Claude Code 빠른 치트시트

## 무엇을 쓸까?
- 항상 지켜야 하는 규칙 → CLAUDE.md
- 파일/디렉터리별 세부 규칙 → Rules
- 반복 작업/참조 문서 → Skills
- 대량 탐색/병렬 검토 → Subagents
- 독립 세션 협업 → Agent teams
- 외부 서비스 연결 → MCP
- 이벤트 기반 자동화 → Hooks
- 여러 기능 묶음 배포 → Plugins
- 조직/커뮤니티 유통 → Marketplaces

## 가장 흔한 조합
- CLAUDE.md + Rules = 프로젝트 규칙 체계
- Skill + MCP = 외부 서비스 사용 가이드 포함 워크플로우
- Skill + Subagent = 병렬 감사/검토
- Hook + MCP = 편집/완료 이벤트 외부 통지
- Plugin = 위 기능 전체 묶음

## 비용 관점
- 항상 로드: CLAUDE.md
- 설명만 기본 로드: Skills
- 실제 도구 사용 전까지 저비용: MCP
- 메인 컨텍스트와 격리: Subagents
- 기본 비용 0: Hooks