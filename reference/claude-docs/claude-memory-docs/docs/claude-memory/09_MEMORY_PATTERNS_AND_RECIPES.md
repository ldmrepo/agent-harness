# 실전 패턴 및 레시피
문서 ID: CC-MEMORY-PATTERNS
버전: v1.0.0

## 1. 작은 프로젝트
- `./CLAUDE.md` 하나로 시작
- build/test/formatting 규칙만 포함

## 2. 팀 프로젝트
- root `CLAUDE.md`
- `.claude/rules/testing.md`
- `.claude/rules/security.md`
- package별 path-specific rules

## 3. 개인 로컬 설정
- `CLAUDE.local.md`에 sandbox URL, 로컬 test fixture, 개인 도구 alias 기록
- `.gitignore` 추가

## 4. 기존 AGENTS.md 재사용
- `CLAUDE.md`에서 `@AGENTS.md` import
- Claude 전용 지침 추가

## 5. memory debugging
- `/memory`로 실제 로드 파일 확인
- `InstructionsLoaded` hook으로 lazy load 추적

## 6. worktree 사용자
- auto memory는 같은 repo 내 worktree 공유
- 개인 공용 지침은 `~/.claude/...` import로 통합
