# 03. 첫 Plugin 만들기 Quickstart

문서 버전: v1.0.0

## 1. 목표
가장 작은 형태의 플러그인을 만들어 로컬에서 테스트한다.

## 2. 기본 절차
### 2.1 디렉토리 생성
```bash
mkdir my-first-plugin
mkdir my-first-plugin/.claude-plugin
mkdir -p my-first-plugin/skills/hello
```

### 2.2 매니페스트 작성
파일: `my-first-plugin/.claude-plugin/plugin.json`

```json
{
  "name": "my-first-plugin",
  "description": "A greeting plugin to learn the basics",
  "version": "1.0.0",
  "author": {
    "name": "Your Name"
  }
}
```

## 3. 첫 skill 작성
파일: `my-first-plugin/skills/hello/SKILL.md`

```markdown
---
description: Greet the user with a friendly message
disable-model-invocation: true
---

Greet the user warmly and ask how you can help them today.
```

## 4. 로컬 테스트
```bash
claude --plugin-dir ./my-first-plugin
```

Claude Code 실행 후:
```text
/my-first-plugin:hello
```

## 5. 인자 받기
`$ARGUMENTS`를 사용하면 skill 실행 시 전달된 인자를 prompt에 주입할 수 있다.

```markdown
---
description: Greet the user with a personalized message
---

# Hello Skill

Greet the user named "$ARGUMENTS" warmly and ask how you can help them today.
```

실행:
```text
/my-first-plugin:hello Alex
```

## 6. 핵심 이해 포인트
- `.claude-plugin/plugin.json`은 플러그인 메타데이터다.
- `skills/<name>/SKILL.md` 구조가 권장 skill 구조다.
- plugin skill 이름은 항상 `plugin-name:skill-name` 형태다.
- 개발 중에는 `--plugin-dir`와 `/reload-plugins`가 핵심이다.
