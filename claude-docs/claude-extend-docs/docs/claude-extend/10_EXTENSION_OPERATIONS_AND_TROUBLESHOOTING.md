# 운영 원칙과 트러블슈팅
문서 ID: CC-EXT-OPS
버전: v1.0.0

## 1. 운영 원칙
- 항상 필요한 것만 항상 로드
- 참조성 내용은 Skills로 이동
- 확장은 작게 시작하고 점진적으로 추가
- Hooks는 deterministic한 것만 맡긴다

## 2. 흔한 문제
### 2.1 CLAUDE.md가 너무 큼
- Rules/Skills로 분리

### 2.2 Skill이 잘못 트리거됨
- description이 겹치거나 모호함
- `disable-model-invocation: true` 검토

### 2.3 MCP 도구가 사라짐
- 연결 상태 재점검
- `/mcp` 확인

### 2.4 메인 컨텍스트가 너무 빨리 찬다
- Subagent 활용
- 항상-로딩 규칙 축소
- 온디맨드 구조로 재설계

### 2.5 조직 표준이 일관되지 않음
- Plugin/Marketplace로 표준화
- managed policy와 managed CLAUDE.md 활용

## 3. 권장 점검 항목
- CLAUDE.md 길이
- Rules 경로 매칭 정확성
- Skill description 품질
- MCP 서버 수와 실제 사용 빈도
- Hook의 context 반환 여부
- Plugin namespace 충돌 여부