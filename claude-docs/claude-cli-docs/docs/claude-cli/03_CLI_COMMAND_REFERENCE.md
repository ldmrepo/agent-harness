# CLI Command Reference
문서 ID: CC-CLI-COMMAND-REF
버전: v1.0.0

## 1. `claude`
interactive session 시작

## 2. `claude "query"`
초기 프롬프트를 포함한 interactive session 시작

## 3. `claude -p "query"`
비대화형 질의 후 종료

## 4. `cat file | claude -p "query"`
stdin 파이프 입력 처리

## 5. `claude -c`
현재 디렉토리의 최근 세션 계속

## 6. `claude -c -p "query"`
최근 세션을 비대화형으로 이어서 사용

## 7. `claude -r "<session>" "query"`
세션 ID 또는 이름으로 특정 세션 재개

## 8. `claude update`
최신 버전으로 업데이트

## 9. `claude auth login`
인증 시작
- `--email`
- `--sso`
- `--console`

## 10. `claude auth logout`
로그아웃

## 11. `claude auth status`
인증 상태 출력
- 기본 JSON
- `--text` human-readable

## 12. `claude agents`
subagent 목록 출력

## 13. `claude auto-mode defaults`
auto mode 내장 classifier rules 출력

## 14. `claude mcp`
MCP server 설정

## 15. `claude plugin`
plugin 설치/관리

## 16. `claude remote-control`
remote control server 시작
