# 04. 로컬 Marketplace Quickstart

문서 버전: v1.0.0

## 1. 목적
가장 빠르게 marketplace를 이해하는 방법은 로컬 디렉터리 기반 예제를 직접 만드는 것이다.

## 2. 디렉터리 구조
```text
my-marketplace/
├── .claude-plugin/
│   └── marketplace.json
└── plugins/
    └── quality-review-plugin/
        ├── .claude-plugin/
        │   └── plugin.json
        └── skills/
            └── quality-review/
                └── SKILL.md
```

## 3. skill 작성
`plugins/quality-review-plugin/skills/quality-review/SKILL.md`

```markdown
---
description: Review code for bugs, security, and performance
disable-model-invocation: true
---

Review the code I've selected or the recent changes for:
- Potential bugs or edge cases
- Security concerns
- Performance issues
- Readability improvements

Be concise and actionable.
```

## 4. plugin manifest 작성
`plugins/quality-review-plugin/.claude-plugin/plugin.json`

```json
{
  "name": "quality-review-plugin",
  "description": "Adds a /quality-review skill for quick code reviews",
  "version": "1.0.0"
}
```

## 5. marketplace.json 작성
`.claude-plugin/marketplace.json`

```json
{
  "name": "my-plugins",
  "owner": {
    "name": "Your Name"
  },
  "plugins": [
    {
      "name": "quality-review-plugin",
      "source": "./plugins/quality-review-plugin",
      "description": "Adds a /quality-review skill for quick code reviews"
    }
  ]
}
```

## 6. 로컬 테스트 절차
```shell
/plugin marketplace add ./my-marketplace
/plugin install quality-review-plugin@my-plugins
```

설치 후:
```shell
/quality-review
```

## 7. 핵심 학습 포인트
- marketplace는 plugin catalog다.
- plugin은 marketplace에 등록된 실제 기능 단위다.
- 설치 시 plugin은 cache로 복사되므로 plugin 외부 경로 참조는 주의해야 한다.
- 로컬 테스트가 끝나면 GitHub/GitLab 기반으로 쉽게 전환할 수 있다.
