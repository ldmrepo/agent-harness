# 03. Agent Teams 활성화와 시작

## 1. 활성화 조건

Agent teams는 기본적으로 비활성화되어 있으며, 실험 기능이다.

## 2. 활성화 방법

### 2.1 settings.json
```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

### 2.2 환경변수
```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

## 3. 버전 조건

Claude Code v2.1.32 이상이 필요하다.

## 4. 첫 팀 시작 예시

```text
I'm designing a CLI tool that helps developers track TODO comments across
their codebase. Create an agent team to explore this from different angles: one
teammate on UX, one on technical architecture, one playing devil's advocate.
```

## 5. 좋은 시작 프롬프트의 특징

- 팀 목적이 명확하다.
- 역할이 서로 겹치지 않는다.
- 병렬 탐색의 가치가 있다.
- 결과 종합 대상이 뚜렷하다.

## 6. 팀 생성 직후 일어나는 일

- 리드가 팀을 생성한다.
- 팀원 세션이 생성된다.
- 공유 작업 목록이 초기화된다.
- 팀원별 역할/프롬프트가 적용된다.
- 리드 터미널에서 팀원 상태를 볼 수 있다.

## 7. 표시 모드 선택

### 7.1 in-process
- 한 터미널 안에서 팀원을 순환하며 확인한다.
- 별도 도구 설치가 거의 필요 없다.

### 7.2 split panes
- 팀원별 pane을 분리해서 동시에 관찰한다.
- tmux 또는 iTerm2 기반 환경이 필요하다.

## 8. 세션별 강제 설정 예시

```bash
claude --teammate-mode in-process
```
