# 도구 아키텍처와 카테고리 분류
문서 ID: CC-TOOLS-CATEGORIES
버전: v1.0.0

## 1. 분류 원칙
도구는 "무엇을 하기 위한 것인가"를 기준으로 분류한다.

## 2. 탐색/이해 도구
- Read
- Glob
- Grep
- LSP

### 역할
- 파일 내용 읽기
- 파일 위치 찾기
- 코드 패턴 검색
- 정의/참조/타입 정보 추적

## 3. 수정 도구
- Edit
- Write
- NotebookEdit

### 역할
- 기존 파일 부분 수정
- 새 파일 생성 또는 전체 덮어쓰기
- Jupyter notebook 셀 편집

## 4. 실행 도구
- Bash
- PowerShell
- WebFetch
- WebSearch

### 역할
- 테스트, 빌드, git, 패키지 관리자 실행
- Windows PowerShell 명령 실행
- URL fetch 및 웹 검색

## 5. 오케스트레이션 도구
- Agent
- AskUserQuestion
- EnterPlanMode
- ExitPlanMode
- EnterWorktree
- ExitWorktree

### 역할
- 별도 컨텍스트 워커 생성
- 요구사항 수집
- 계획 모드 진입/종료
- 격리된 worktree 생성/복귀

## 6. 작업/스케줄링 도구
- TaskCreate / TaskGet / TaskList / TaskUpdate / TaskStop
- CronCreate / CronList / CronDelete
- TodoWrite

## 7. 확장/MCP/협업 도구
- ListMcpResourcesTool
- ReadMcpResourceTool
- ToolSearch
- Skill
- TeamCreate / TeamDelete / SendMessage
