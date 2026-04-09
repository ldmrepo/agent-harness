# Agent Teams Quick Cheat Sheet

## 활성화
```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

## 팀 시작 예시
```text
Create an agent team to review this system from three angles:
- security
- performance
- test coverage
```

## 직접 제어 예시
```text
Create a team with 4 teammates.
Use Sonnet for each teammate.
```

```text
Spawn an architect teammate and require plan approval before implementation.
```

```text
Ask the researcher teammate to shut down
```

```text
Clean up the team
```

## 언제 쓰나
- 병렬 조사
- 경쟁 가설 디버깅
- 계층 분업
- 다관점 리뷰

## 언제 피하나
- 순차 의존성이 강한 작업
- 같은 파일을 여러 팀원이 만져야 하는 작업
- 작은 작업

## 핵심 차이
- Subagent: 메인 에이전트에게만 결과 반환
- Agent team: 팀원끼리 직접 메시징 + 공유 task list
