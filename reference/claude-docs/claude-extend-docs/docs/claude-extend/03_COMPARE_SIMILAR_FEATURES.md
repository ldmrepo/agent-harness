# 유사 기능 비교
문서 ID: CC-EXT-COMPARE
버전: v1.0.0

## 1. Skill vs Subagent
### Skill
- 재사용 가능한 지식/워크플로우
- 같은 컨텍스트에 로드되어 활용
- 참조용 또는 명령형 워크플로우에 적합

### Subagent
- 별도 컨텍스트에서 독립 실행
- 결과만 요약되어 돌아옴
- 대량 탐색, 긴 작업, 병렬 작업에 적합

## 2. CLAUDE.md vs Skill
### CLAUDE.md
- 모든 세션에 자동 로드
- 항상 지켜야 하는 규칙에 적합

### Skill
- 필요할 때만 로드
- 참조 문서, 체크리스트, 워크플로우에 적합

## 3. CLAUDE.md vs Rules vs Skills
- CLAUDE.md: 프로젝트 전체 공통 핵심 규칙
- Rules: 파일 경로나 유형에 따라 조건부 로드되는 세부 규칙
- Skills: 작업 단위로 호출되는 온디맨드 지식/워크플로우

## 4. Subagent vs Agent team
- Subagent: 메인 세션 내부의 격리된 작업자
- Agent team: 완전히 독립된 Claude Code 세션들의 협업 구조

## 5. MCP vs Skill
- MCP: 도구/데이터 접근 제공
- Skill: 그 도구를 잘 쓰는 방법과 워크플로우 제공