# Skill 공유와 배포

## 1. 공유 범위

### Project skills
`.claude/skills/`를 저장소에 커밋하여 팀 공유

### Plugins
plugin 내부 `skills/` 디렉토리에 포함

### Managed
조직 차원의 managed settings 기반 배포

## 2. 배포 전략

- 개인 실험용: personal skills
- 팀 표준화: project skills
- 조직 재사용: plugins 또는 managed
- 여러 저장소 공용: plugin 우선 고려

## 3. 네임스페이스

plugin skills는 `plugin-name:skill-name` 네임스페이스로 충돌을 피한다.

## 4. 명령 기반 작업에서의 배포 팁

직접 side effect가 있는 skill은 다음 조합 권장:
- `disable-model-invocation: true`
- 필요한 `allowed-tools`만 허용
- 필요 시 hooks와 결합
- 가능하면 supporting docs 포함

## 5. 시각화 skill 패턴

skill은 스크립트를 실행하여 HTML, 리포트, 시각화 출력을 만들 수 있다.

예시 패턴:
- codebase explorer
- dependency graph
- API docs visualization
- DB schema map
- test coverage report

핵심 원리:
- Claude는 orchestration 담당
- 실제 heavy lifting은 bundled script 담당
