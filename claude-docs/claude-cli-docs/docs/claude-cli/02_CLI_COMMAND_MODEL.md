# CLI 명령 체계와 실행 모델
문서 ID: CC-CLI-COMMAND-MODEL
버전: v1.0.0

## 1. 명령 체계 분류
CLI command는 다음 카테고리로 분류한다.
- 세션 시작/질의
- 세션 재개/포크
- 인증/업데이트
- 확장 관리
- 원격 제어
- 특수 관리 명령

## 2. 세션 시작 계열
- `claude`
- `claude "query"`
- `claude -p "query"`
- `cat file | claude -p "query"`

## 3. 세션 재개 계열
- `claude -c`
- `claude -c -p "query"`
- `claude -r "<session>" "query"`

## 4. 인증/업데이트 계열
- `claude update`
- `claude auth login`
- `claude auth logout`
- `claude auth status`

## 5. 확장/도구 관리 계열
- `claude agents`
- `claude mcp`
- `claude plugin`
- `claude auto-mode defaults`

## 6. 원격 계열
- `claude remote-control`

## 7. command와 flag의 관계
command는 기능 단위를 나타내고, flag는 그 기능의 실행 조건과 모드를 제어한다.
