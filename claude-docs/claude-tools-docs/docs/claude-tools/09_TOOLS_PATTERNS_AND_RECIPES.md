# 도구 활용 패턴 및 실전 레시피
문서 ID: CC-TOOLS-PATTERNS
버전: v1.0.0

## 1. 코드베이스 탐색 패턴
Glob → Grep → Read → LSP

## 2. 안전한 수정 패턴
Read → Edit → LSP 확인 → Bash(test)

## 3. 대규모 조사 패턴
Agent(subagent) → 요약 결과 회수

## 4. 병렬 작업 패턴
EnterWorktree → 분리 세션 → ExitWorktree

## 5. 웹 문서 조사 패턴
WebSearch → WebFetch → 코드 반영

## 6. 작업 추적 패턴
TaskCreate → TaskUpdate → TaskList → TaskStop

## 7. 반복 프롬프트 패턴
CronCreate → CronList → CronDelete

## 8. Windows 운영 패턴
PowerShell + hooks(shell=powershell) + defaultShell=powershell
