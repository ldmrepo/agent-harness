# Claude Code Hooks 개요
문서 ID: CC-HOOKS-OVERVIEW
버전: v1.1.0

## 1. 정의
Hooks는 Claude Code 수명주기의 특정 시점에 자동으로 실행되는 사용자 정의 자동화 메커니즘이다.

## 2. Hook의 본질
Hooks는 단순 스크립트 실행 기능이 아니라 Claude Code 하네스의 정책·자동화·관측 계층이다.
Hooks는 다음을 수행할 수 있다.
- 도구 실행 전 검증
- 권한 요청 자동 승인/거부
- 도구 실행 후 검증 및 후처리
- 세션 시작 시 환경 준비
- 컨텍스트 로딩 감시
- 알림, 감사, 로깅
- task/team/worktree 흐름 제어

## 3. Hook이 필요한 이유
CLAUDE.md는 지침이지만 hooks는 결정론적 실행 계층이다.
즉, "항상 발생해야 하는 작업"은 hooks가 더 적합하다.

## 4. Hook의 실행 단위
Hook는 다음 타입 중 하나로 구현된다.
- command
- http
- prompt
- agent

## 5. Hook의 핵심 가치
- 정책 강제
- 자동화
- 품질 게이트
- 보안 게이트
- 운영 관측성
- 외부 시스템 연계

## 6. CLAUDE.md / Skill / MCP / Hook 차이
- CLAUDE.md: 지속 지침
- Skill: 재사용 가능한 워크플로우
- MCP: 외부 도구 연결
- Hook: 특정 이벤트에서 자동 실행되는 제어 로직
