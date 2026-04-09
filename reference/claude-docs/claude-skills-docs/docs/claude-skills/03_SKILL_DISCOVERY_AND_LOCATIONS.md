# Skill 위치와 발견 방식

## 1. 저장 위치별 범위

| 범위 | 경로 | 적용 범위 |
|---|---|---|
| Enterprise | managed settings 기준 위치 | 조직 전체 |
| Personal | `~/.claude/skills/<skill-name>/SKILL.md` | 모든 개인 프로젝트 |
| Project | `.claude/skills/<skill-name>/SKILL.md` | 현재 프로젝트 |
| Plugin | `<plugin>/skills/<skill-name>/SKILL.md` | 플러그인 활성 영역 |

## 2. 우선순위

동일 이름 skill이 여러 레벨에 있으면 다음 우선순위를 따른다.

- enterprise
- personal
- project

plugin skills는 `plugin-name:skill-name` 네임스페이스를 가지므로 직접 충돌하지 않는다.

## 3. Nested discovery

Claude Code는 하위 디렉토리 작업 시 nested `.claude/skills/`도 자동 탐색한다.

예:
- `packages/frontend/.claude/skills/`

이는 monorepo에 적합하다.

## 4. Additional directories

`--add-dir`는 원칙적으로 file access용이지만, skills는 예외적으로 자동 로드된다.

주의:
- `.claude/skills/`는 추가 디렉토리에서 로드됨
- 다른 `.claude/` 설정은 일반적으로 로드되지 않음
- CLAUDE.md는 기본적으로 로드되지 않으며 `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1`이 필요함

## 5. Skill 디렉토리 기본 구조

```text
my-skill/
├── SKILL.md
├── template.md
├── examples/
│   └── sample.md
└── scripts/
    └── validate.sh
```

`SKILL.md`는 필수이며, 나머지는 선택이다.
