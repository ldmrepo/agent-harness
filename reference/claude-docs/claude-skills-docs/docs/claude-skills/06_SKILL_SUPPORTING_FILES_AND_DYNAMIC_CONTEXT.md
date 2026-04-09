# Supporting Files와 Dynamic Context Injection

## 1. Supporting files 목적

`SKILL.md`를 간결하게 유지하면서 큰 참고자료를 분리할 수 있다.

예:
```text
my-skill/
├── SKILL.md
├── reference.md
├── examples.md
└── scripts/
    └── helper.py
```

## 2. supporting files 연결 방식

`SKILL.md`에서 supporting file을 명시적으로 참조한다.

예:
```markdown
## Additional resources

- For complete API details, see [reference.md](reference.md)
- For usage examples, see [examples.md](examples.md)
```

## 3. 권장 기준

- `SKILL.md`는 500줄 이하 권장
- 대형 API 스펙, 예제 모음, 정책 문서는 별도 파일로 분리

## 4. Dynamic context injection

`` !`<command>` `` 구문으로 skill 본문 전처리 시 shell command를 실행할 수 있다.

예:
```yaml
---
name: pr-summary
description: Summarize changes in a pull request
context: fork
agent: Explore
allowed-tools: Bash(gh *)
---

- PR diff: !`gh pr diff`
- PR comments: !`gh pr view --comments`
```

동작 순서:
1. shell command 실행
2. 출력이 placeholder를 대체
3. Claude는 렌더링 완료된 skill 본문만 받음

## 5. 멀티라인 명령

```markdown
```!
node --version
npm --version
git status --short
```
```

## 6. 정책으로 shell execution 끄기

`disableSkillShellExecution: true` 설정 시 user/project/plugin/additional-directory 출처 skill의 shell execution을 막을 수 있다.

대체 문자열:
```text
[shell command execution disabled by policy]
```
