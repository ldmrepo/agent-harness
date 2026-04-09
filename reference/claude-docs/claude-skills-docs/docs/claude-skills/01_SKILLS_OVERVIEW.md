# Skills 개요

## 1. 정의

Skills는 Claude Code의 기능을 확장하는 재사용 가능한 지식, 워크플로우, 지침 단위이다. 각 skill은 `SKILL.md`를 중심으로 구성되며, Claude는 관련성이 있을 때 자동으로 로드하거나 사용자가 `/skill-name` 형태로 직접 호출할 수 있다.

## 2. 기본 원리

- skill은 markdown 기반이다.
- 핵심 진입점은 `SKILL.md`이다.
- Claude는 description을 보고 자동 사용 여부를 판단한다.
- 사용자는 `/skill-name`으로 직접 실행할 수 있다.
- 기존 `.claude/commands/*.md`도 계속 동작하지만, skills가 더 확장된 형식이다.

## 3. Skill이 해결하는 문제

- 반복적인 작업 절차 표준화
- 프로젝트/도메인 지식 재사용
- 참조형 지침과 실행형 워크플로우의 분리
- supporting files를 통한 대형 참조 자료 관리
- subagent와 결합한 격리 실행

## 4. Agent Skills 표준

Claude Code skills는 Agent Skills 오픈 표준을 따르며, Claude Code는 여기에 다음 기능을 추가한다.

- invocation control
- subagent execution
- dynamic context injection

## 5. Commands와의 관계

기존 custom commands는 skills로 통합되었다.

- `.claude/commands/deploy.md`
- `.claude/skills/deploy/SKILL.md`

둘 다 `/deploy`를 만든다. 다만 skills는 다음 추가 기능이 있다.

- supporting files
- frontmatter
- Claude의 자동 관련성 로딩
