# 도구 권한 모델
문서 ID: CC-TOOLS-PERMISSIONS
버전: v1.0.0

## 1. 개요
Claude Code 도구는 동일한 권한 정책을 사용하지 않는다.
대체로 읽기/탐색/오케스트레이션은 무권한이고, 수정/실행/웹 접근은 권한이 필요하다.

## 2. 권한이 필요한 주요 도구
- Bash
- Edit
- NotebookEdit
- PowerShell
- Skill
- WebFetch
- WebSearch
- Write
- ExitPlanMode

## 3. 권한이 필요 없는 주요 도구
- Agent
- AskUserQuestion
- Glob
- Grep
- Read
- LSP
- Task*
- Cron*
- EnterPlanMode
- EnterWorktree
- ListMcpResourcesTool
- ReadMcpResourceTool
- ToolSearch

## 4. 운영 의미
### 4.1 무권한 도구
- 코드베이스 조사
- 계획 수립
- 작업 조율
- 리소스 조회

### 4.2 권한 도구
- 실제 시스템/파일 변경
- 외부 네트워크 사용
- 프로젝트 상태를 바꾸는 행동

## 5. deny / allow와의 관계
도구 이름은 permissions 설정에서 그대로 사용한다.
특정 도구를 완전히 비활성화하려면 deny 배열에 추가한다.
