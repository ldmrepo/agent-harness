# Claude Code Tools 개요
문서 ID: CC-TOOLS-OVERVIEW
버전: v1.0.0

## 1. 정의
Claude Code Tools는 Claude가 프로젝트를 이해하고 수정하며 검증하기 위해 사용하는 내장 실행 수단이다.

## 2. 도구의 본질
도구가 없다면 Claude는 텍스트 응답만 생성한다.
도구가 있기 때문에 Claude는 다음을 수행할 수 있다.
- 파일 읽기
- 코드 검색
- 셸 명령 실행
- 파일 편집 및 생성
- 웹 검색 및 URL fetch
- subagent 생성
- task / cron / worktree 제어
- MCP 리소스 접근

## 3. 도구 체계의 의미
도구는 Claude Code 하네스의 실행 계층이다.
모델이 판단하고, 도구가 실제 행동을 수행한다.

## 4. 도구 이름의 중요성
도구 이름은 다음 설정에서 그대로 사용된다.
- permission rules
- subagent tool lists
- hook matchers
- deny array

## 5. 확장과의 관계
- 새 도구 추가: MCP server 연결
- 재사용 가능한 워크플로우 확장: Skill 도구를 통해 실행
- 별도 컨텍스트 작업자: Agent 도구를 통해 subagent 실행
