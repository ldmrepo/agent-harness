# 12. 활용 패턴과 체크리스트

## 1. 대표 패턴
- Sentry 연결 후 최근 오류 분석
- GitHub 연결 후 PR 리뷰/이슈 생성
- PostgreSQL 연결 후 운영 리포트 질의
- 브라우저/디자인/협업 도구 연결 후 워크플로우 자동화

## 2. 설치 전 체크
- 이 서버를 신뢰할 수 있는가?
- 팀 공유가 필요한가, 개인 전용인가?
- HTTP/stdio 중 어떤 방식이 적합한가?
- 인증 방식은 OAuth인가, 헤더 기반인가?

## 3. 운영 중 체크
- `/mcp`에서 상태 확인
- 필요한 서버만 유지
- 결과가 너무 크면 limit/page/summary 설계
- 프로젝트 공유 설정과 개인 설정 충돌 여부 점검

## 4. 장애 대응 순서
1. `claude mcp list`
2. `claude mcp get <name>`
3. `/mcp`에서 인증/연결 상태 확인
4. 프록시/환경 변수 확인
5. 스코프 중복 및 우선순위 확인

## 5. 추천 문서 세트 연결
MCP를 실무에서 안정적으로 쓰려면 다음 문서와 함께 보는 것이 좋다.
- Hooks
- Tools reference
- Environment variables
- Extend Claude Code
- Security
