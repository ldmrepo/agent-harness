# Import, AGENTS.md, 공유 지침
문서 ID: CC-MEMORY-IMPORTS
버전: v1.0.0

## 1. import 문법
CLAUDE.md는 `@path/to/file` 문법으로 다른 파일을 import할 수 있다.

예:
```text
See @README for project overview.
- git workflow @docs/git-instructions.md
```

## 2. 경로 규칙
- 상대 경로: import를 포함한 파일 기준
- 절대 경로: 직접 지정 가능
- 최대 재귀 깊이: 5 hop

## 3. 외부 import 승인
프로젝트에서 외부 import를 처음 만날 때 Claude Code는 승인 dialog를 표시한다.

## 4. 개인 지침 공유
worktree 간 공유가 필요한 개인 지침은 home directory 파일을 import하는 방식이 적합하다.
예:
```text
@~/.claude/my-project-instructions.md
```

## 5. AGENTS.md 연계
Claude Code는 `AGENTS.md`를 직접 읽지 않는다.
기존 저장소가 AGENTS.md를 사용 중이면 `CLAUDE.md`에서 import해 재사용한다.

예:
```md
@AGENTS.md

## Claude Code
Use plan mode for changes under `src/billing/`.
```
