# 05. Agent Team 아키텍처와 동작 메커니즘

## 1. 구성 요소

### 1.1 Team lead
- 메인 Claude Code 세션
- 팀 생성자
- 조정자
- 결과 종합자

### 1.2 Teammates
- 개별 Claude Code 인스턴스
- 독립 컨텍스트 윈도우 보유
- 역할별 작업 수행

### 1.3 Shared task list
- 팀 전체가 공유하는 작업 저장소
- pending / in progress / completed 상태 관리
- 의존성 관리

### 1.4 Mailbox / messaging
- 팀원 간 메시지 교환 채널
- 리드와 팀원 간 통신
- broadcast와 개별 message 지원

## 2. 시작 방식

### 2.1 사용자가 명시적으로 팀 요청
가장 일반적인 방식이다.

### 2.2 Claude가 팀 구성을 제안
작업이 병렬화에 적합하다고 판단되면 팀 생성을 제안할 수 있다.

## 3. 저장 구조

- Team config: `~/.claude/teams/{team-name}/config.json`
- Task list: `~/.claude/tasks/{team-name}/`

이 파일들은 런타임 상태 저장소이며, 수동 편집 대상이 아니다.

## 4. 리드와 팀원 관계

- 리드는 고정된다.
- 생성 후 중간에 다른 팀원을 리드로 승격할 수 없다.
- 한 세션은 동시에 하나의 팀만 리드할 수 있다.

## 5. Context 로딩

팀원은 일반 세션처럼 프로젝트 컨텍스트를 읽는다.

로드되는 대표 요소:
- CLAUDE.md
- MCP servers
- Skills
- spawn prompt

자동으로 승계되지 않는 것:
- 리드의 전체 대화 이력

## 6. Task dependency 해제

선행 태스크 완료 시, 해당 태스크를 의존하던 후속 태스크가 자동으로 unblock된다.

## 7. 동시성 제어

태스크 claim에는 파일 잠금이 사용되어 여러 팀원이 동시에 같은 태스크를 가져가는 경쟁 상태를 줄인다.
