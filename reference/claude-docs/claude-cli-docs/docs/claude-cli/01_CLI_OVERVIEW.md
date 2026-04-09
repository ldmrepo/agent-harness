# Claude Code CLI 개요
문서 ID: CC-CLI-OVERVIEW
버전: v1.0.0

## 1. 정의
Claude Code CLI는 Claude Code를 터미널에서 실행·제어하기 위한 명령행 인터페이스이다.

## 2. CLI의 역할
CLI는 Claude Code를 다음 네 방식으로 사용하게 한다.
- 대화형 세션 시작
- 비대화형 단발 실행
- 기존 세션 재개 및 포크
- 자동화/스크립트/CI 연계

## 3. 핵심 실행 모델
### 3.1 interactive mode
- `claude`
- 장기 세션, 대화형 협업, 탐색/수정/검증 중심

### 3.2 print/headless mode
- `claude -p "query"`
- 응답 출력 후 종료
- 자동화, 스크립트, 파이프라인 통합에 적합

### 3.3 session resume model
- `--continue`
- `--resume`
- `--fork-session`

### 3.4 isolated execution model
- `--worktree`
- `--remote`
- `--remote-control`

## 4. CLI를 이해하는 핵심 축
- command: 무엇을 실행하는가
- flag: 어떻게 실행하는가
- settings/env: 기본 동작을 어떻게 바꾸는가

## 5. 운영 관점 핵심 질문
- interactive로 쓸 것인가, print/headless로 쓸 것인가
- 새 세션인가, 재개 세션인가
- 권한 모드는 무엇인가
- 기본 프롬프트를 유지할 것인가, append할 것인가
- 로컬 실행인가, 웹/원격 제어인가
