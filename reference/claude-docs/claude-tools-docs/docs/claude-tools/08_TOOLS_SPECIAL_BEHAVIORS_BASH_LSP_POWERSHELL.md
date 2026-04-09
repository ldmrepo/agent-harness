# Bash / LSP / PowerShell 특수 동작
문서 ID: CC-TOOLS-SPECIAL
버전: v1.0.0

## 1. Bash tool behavior
### 1.1 별도 프로세스 실행
각 Bash 명령은 별도 프로세스에서 실행된다.

### 1.2 유지되는 것
- working directory는 명령 간 유지된다.
- CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1 이면 각 명령 후 프로젝트 디렉토리로 복귀한다.

### 1.3 유지되지 않는 것
- 환경변수는 명령 간 유지되지 않는다.
- 한 명령의 export는 다음 명령에 남지 않는다.

### 1.4 환경 지속 방법
- CLAUDE_ENV_FILE 사용
- SessionStart hook 사용

## 2. LSP tool behavior
### 목적
language server 기반 코드 인텔리전스 제공
### 기능
- 정의로 이동
- 참조 찾기
- 특정 위치 타입 정보
- 파일/워크스페이스 심볼
- 인터페이스 구현체
- call hierarchy
### 특징
- 무권한
- 파일 편집 후 타입 오류/경고를 자동 제공
- code intelligence plugin 설치 전에는 비활성

## 3. PowerShell tool behavior
### 활성화
CLAUDE_CODE_USE_POWERSHELL_TOOL=1

### 특징
- Windows native only
- Git Bash alongside 등록
- defaultShell / hook shell / skill shell 연동 가능

### preview 제한
- auto mode 미지원
- profiles 미로딩
- sandboxing 미지원
- WSL 미지원
- Claude Code 시작에는 Git Bash 필요
