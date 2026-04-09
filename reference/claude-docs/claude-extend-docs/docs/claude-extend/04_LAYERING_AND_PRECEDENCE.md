# 레이어링과 우선순위
문서 ID: CC-EXT-LAYERING
버전: v1.0.0

## 1. CLAUDE.md
CLAUDE.md 파일은 additive하게 누적된다.
- 작업 디렉터리와 상위 디렉터리의 파일이 시작 시 로드
- 하위 디렉터리 파일은 접근 시 지연 로드
- 더 구체적인 파일이 일반적으로 더 강한 영향

## 2. Skills
Skill은 이름 기준 override된다.
- 관리 > 사용자 > 프로젝트 우선
- plugin skill은 namespace로 충돌 회피

## 3. Subagents
Subagent도 이름 또는 정의 기준 override가 존재한다.
- 관리 > CLI flag > 프로젝트 > 사용자 > 플러그인 순

## 4. MCP
MCP 서버는 이름 기준 override된다.
- local > project > user

## 5. Hooks
Hooks는 override가 아니라 merge된다.
- 모든 소스의 matching hook이 함께 발화

## 6. 설계 주의점
- additive 계층은 충돌 지침을 만들기 쉽다.
- override 계층은 이름 설계를 잘해야 한다.
- merge 계층은 중복/경쟁 실행을 고려해야 한다.