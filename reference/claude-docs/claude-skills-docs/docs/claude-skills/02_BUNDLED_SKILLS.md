# Bundled Skills

## 1. 개요

Bundled skills는 Claude Code에 기본 포함되는 skill 세트다. built-in commands와 달리 prompt-based로 동작하므로, Claude가 도구를 조합하고 병렬 작업을 수행하며 코드베이스에 적응적으로 대응할 수 있다.

## 2. 주요 bundled skills

### `/batch <instruction>`
대규모 코드 변경을 병렬 오케스트레이션한다.

주요 특성:
- 코드베이스 조사
- 작업을 5~30개 단위로 분해
- 승인 후 unit별 background agent 생성
- isolated git worktree 사용
- 각 agent가 구현, 테스트, PR 생성 수행

예시:
```text
/batch migrate src/ from Solid to React
```

### `/claude-api`
Claude API reference material을 로드한다.

포함 범위:
- Python
- TypeScript
- Java
- Go
- Ruby
- C#
- PHP
- cURL
- Agent SDK reference 일부

자동 활성 예:
- `anthropic`
- `@anthropic-ai/sdk`
- `claude_agent_sdk`

### `/debug [description]`
현재 세션의 debug logging을 활성화하고 로그를 분석한다.

### `/loop [interval] <prompt>`
세션이 열려 있는 동안 프롬프트를 주기적으로 반복 실행한다.

예시:
```text
/loop 5m check if the deploy finished
```

### `/simplify [focus]`
최근 변경 파일을 검토하고 품질/재사용성/효율성 문제를 찾고 수정한다.

예시:
```text
/simplify focus on memory efficiency
```

## 3. Built-in commands와 차이

- built-in commands: 고정 로직
- bundled skills: prompt 기반 플레이북

즉, bundled skills는 Claude가 상황에 맞게 실행 전략을 조정할 수 있다.
