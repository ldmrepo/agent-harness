# 운영, 보안, 트러블슈팅
문서 ID: CC-TOOLS-OPS
버전: v1.0.0

## 1. 운영 원칙
- 무권한 도구는 탐색/조사용으로 적극 활용
- 권한 도구는 permissions와 hooks로 감싼다
- Bash와 Write는 가장 영향력이 큰 도구로 취급한다

## 2. 보안 포인트
- Bash / PowerShell / Write / Edit / Web* 는 영향 범위가 큼
- MCP 도구는 외부 시스템 연결이므로 별도 검토 필요
- deny array와 permission rules로 최소 권한 원칙 적용

## 3. 주의점
### 3.1 Bash 환경이 안 남는다
export는 다음 명령으로 유지되지 않음

### 3.2 LSP가 안 된다
code intelligence plugin 및 language server 설치 필요

### 3.3 PowerShell이 안 된다
환경변수 미설정, native Windows 아님, preview 제한 가능성

## 4. 점검 방법
- 세션에서 "What tools do you have access to?" 질문
- 정확한 MCP tool 이름은 /mcp 확인
- permissions / hooks / settings와 함께 교차 점검
