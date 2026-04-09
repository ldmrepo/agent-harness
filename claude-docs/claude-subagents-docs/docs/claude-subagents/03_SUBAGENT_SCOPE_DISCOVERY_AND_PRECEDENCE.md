# 03. Subagent 범위, 발견 방식, 우선순위

## 1. 배치 위치

Subagent는 여러 범위에 정의할 수 있다.

1. Managed settings
2. `--agents` CLI flag
3. `.claude/agents/`
4. `~/.claude/agents/`
5. Plugin의 `agents/`

## 2. 우선순위

동일한 이름의 subagent가 여러 곳에 있으면 높은 우선순위가 승리한다.

1. Managed
2. CLI `--agents`
3. Project `.claude/agents/`
4. User `~/.claude/agents/`
5. Plugin

즉, 같은 이름을 재정의할 때는 충돌보다 override로 이해하면 된다.

## 3. Project scope

`.claude/agents/` 아래의 subagent는 현재 프로젝트 전용이다.

### 장점
- 팀과 버전관리 가능
- 프로젝트 구조/도메인에 특화 가능
- 팀 공통 workflow 표준화 가능

### 적합한 예
- monorepo 전용 reviewer
- 특정 서비스용 DB query agent
- 사내 API 규칙을 따르는 implementer

## 4. User scope

`~/.claude/agents/` 아래의 subagent는 모든 프로젝트에 사용 가능하다.

### 장점
- 개인 생산성 도구로 재사용 가능
- 여러 저장소에 공통 적용 가능

### 적합한 예
- 개인 코드 리뷰어
- 개인 디버거
- 개인 문서 정리 agent

## 5. CLI `--agents`

일회성 세션용 정의다. 디스크에 저장되지 않는다.

### 적합한 상황
- 실험
- CI/스크립트
- 임시 자동화

## 6. Plugin scope

Plugin에 포함된 subagent는 배포와 재사용에 강하다.  
다만 보안상 제한이 있어 plugin subagent에서는 `hooks`, `mcpServers`, `permissionMode` 필드가 무시된다.

## 7. Discovery

프로젝트 subagent는 현재 작업 디렉토리 기준으로 발견된다.  
`--add-dir`는 파일 접근만 부여하며, subagent discovery 대상은 아니다.

즉, 추가 디렉토리에서 subagent를 자동 발견하는 방식에 기대면 안 된다.

## 8. 운영 권장안

- 팀 공용 = `.claude/agents/`
- 개인 공용 = `~/.claude/agents/`
- 배포형 = plugin
- 실험/임시 = `--agents`
