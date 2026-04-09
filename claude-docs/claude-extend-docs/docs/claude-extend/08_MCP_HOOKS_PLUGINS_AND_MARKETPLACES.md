# MCP, Hooks, Plugins, Marketplaces
문서 ID: CC-EXT-INTEGRATIONS
버전: v1.0.0

## 1. MCP
MCP는 Claude를 외부 서비스와 연결한다.
예:
- DB
- Slack
- 브라우저
- 사내 도구

## 2. Hooks
Hooks는 이벤트 기반 자동화 계층이다.
예:
- 파일 수정 후 lint
- 위험 명령 차단
- 알림 전송

## 3. Plugins
Plugin은 skill, hook, subagent, MCP server를 하나로 묶어 배포하는 단위다.
적합한 경우:
- 여러 저장소에 같은 설정 재사용
- 팀 공유
- 기능 모듈화

## 4. Marketplaces
Marketplace는 plugin을 배포/발견하는 계층이다.
- 공식 마켓플레이스
- 조직/사내 마켓플레이스
- 커뮤니티 마켓플레이스

## 5. 결합 패턴
- MCP + Skill: 연결 + 사용 지식
- Hook + MCP: 이벤트 발생 시 외부 작업
- Plugin = Skill + Hook + Subagent + MCP 묶음