# Claude Code Environment Variables 개요
문서 ID: CC-ENV-OVERVIEW
버전: v1.0.0

## 1. 정의
Environment variables는 Claude Code의 실행 동작을 제어하는 런타임 설정값이다.

## 2. 역할
Environment variables는 다음을 제어한다.
- 인증 방식과 API 라우팅
- 클라우드 제공자(Bedrock / Vertex / Foundry) 선택
- 모델 선택 및 추론 깊이
- 컨텍스트 압축, auto memory, CLAUDE.md 로딩
- Bash 실행, timeout, 출력 길이
- MCP / plugin / IDE 연결 동작
- OpenTelemetry 및 디버그 로그
- 기능 활성화/비활성화

## 3. 설정 위치
- 셸에서 `export` 후 `claude` 실행
- settings.json의 `env` 키에 등록
- 팀/조직 배포 시 settings 계층을 통해 공통 반영

## 4. 핵심 성격
Environment variables는 CLI flags와 달리 실행 전 환경을 바꾸는 제어면이다.
일부 변수는 settings보다 우선하거나 특정 플래그와 직접 연결된다.

## 5. 문서 해석 원칙
변수는 개별적으로 보기보다 다음 묶음으로 봐야 한다.
- 인증/라우팅
- 모델/추론
- 컨텍스트/메모리
- 쉘/출력/런타임
- MCP/플러그인/IDE
- 네트워크/보안/관측성
- 기능 토글
