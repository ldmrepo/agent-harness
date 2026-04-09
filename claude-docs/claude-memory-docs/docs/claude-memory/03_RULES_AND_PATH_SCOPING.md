# `.claude/rules/`와 경로 범위 규칙
문서 ID: CC-MEMORY-RULES
버전: v1.0.0

## 1. 목적
대규모 프로젝트에서는 모든 지침을 하나의 CLAUDE.md에 넣지 말고 `.claude/rules/`로 분리한다.

## 2. 기본 구조
```text
.claude/
├── CLAUDE.md
└── rules/
    ├── code-style.md
    ├── testing.md
    └── security.md
```

## 3. unconditional rule
`paths` frontmatter가 없는 규칙은 세션 시작 시 로드된다.

## 4. path-specific rule
YAML frontmatter의 `paths` 필드로 특정 파일 패턴에만 적용할 수 있다.

예시:
```md
---
paths:
  - "src/api/**/*.ts"
---

# API Rules
- Include input validation
- Use standard error response format
```

## 5. glob 패턴 예시
- `**/*.ts`
- `src/**/*`
- `*.md`
- `src/components/*.tsx`
- `src/**/*.{ts,tsx}`

## 6. user-level rules
`~/.claude/rules/`의 규칙은 모든 프로젝트에 적용된다.

## 7. symlink 공유
`.claude/rules/`는 symlink를 지원하므로 여러 프로젝트에서 공용 룰셋을 공유할 수 있다.
