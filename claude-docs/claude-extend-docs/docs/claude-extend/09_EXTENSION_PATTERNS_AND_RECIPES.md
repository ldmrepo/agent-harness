# 확장 패턴과 레시피
문서 ID: CC-EXT-PATTERNS
버전: v1.0.0

## 1. 최소 시작 패턴
- CLAUDE.md만 먼저 도입
- 필요해질 때 Rules/Skills/Hooks 추가

## 2. 프로젝트 표준 패턴
- CLAUDE.md: 공통 규칙
- Rules: 파일 경로별 규칙
- Hooks: lint/test guardrail

## 3. 배포 자동화 패턴
- Skill `/deploy`
- Hook으로 수정 후 lint
- MCP로 배포 대상 시스템 연동

## 4. 대형 코드베이스 탐색 패턴
- CLAUDE.md 최소화
- 큰 참조 문서는 Skills
- 조사 작업은 Subagent
- 여러 가설 경쟁은 Agent team

## 5. 조직 배포 패턴
- 관리 정책 + managed CLAUDE.md
- 사내 Plugin
- Marketplace로 표준 배포

## 6. 데이터/서비스 연동 패턴
- MCP로 외부 시스템 연결
- Skill로 데이터 모델/쿼리 규칙 설명
- Hook으로 이벤트 기반 알림/검증