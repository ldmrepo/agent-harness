# Claude Code Memory Cheat Sheet

## 파일 종류
- `CLAUDE.md`: 프로젝트/사용자/조직 지침
- `CLAUDE.local.md`: 개인 프로젝트 전용 지침
- `.claude/rules/*.md`: 모듈화된 규칙
- `MEMORY.md`: auto memory 인덱스

## 어디에 둘까?
- 공통 프로젝트 규칙: `./CLAUDE.md`
- 개인 프로젝트 선호도: `./CLAUDE.local.md`
- 언어/디렉토리별 규칙: `.claude/rules/`
- 전역 개인 규칙: `~/.claude/CLAUDE.md`, `~/.claude/rules/`

## 핵심 명령/설정
- `/init`: 시작 CLAUDE.md 생성
- `/memory`: 로드 파일/auto memory 확인
- `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`: auto memory 끄기
- `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1`: `--add-dir` 대상의 CLAUDE.md 로드

## 운영 원칙
- CLAUDE.md는 짧게, 규칙은 구체적으로
- 큰 지침은 rules/import로 분리
- auto memory는 Claude의 학습, CLAUDE.md는 사용자의 규칙
