# 로딩 순서와 우선순위
문서 ID: CC-MEMORY-LOADING
버전: v1.0.0

## 1. 상위 디렉토리 탐색
Claude Code는 현재 작업 디렉토리에서 루트 방향으로 올라가며 `CLAUDE.md`와 `CLAUDE.local.md`를 찾는다.

예:
작업 디렉토리: `foo/bar/`
로드 대상:
- `foo/bar/CLAUDE.md`
- `foo/bar/CLAUDE.local.md`
- `foo/CLAUDE.md`
- `foo/CLAUDE.local.md`

## 2. additive 모델
발견된 파일들은 서로 override되는 것이 아니라 컨텍스트에 이어 붙여진다.

## 3. 동일 디렉토리 내 순서
같은 디렉토리에서는 `CLAUDE.md` 다음에 `CLAUDE.local.md`가 append된다.

## 4. 하위 디렉토리 파일
하위 디렉토리의 `CLAUDE.md` / `CLAUDE.local.md`는 시작 시 전부 로드되지 않고, 해당 디렉토리 파일을 읽을 때 lazy-load된다.

## 5. additional directories
`--add-dir` 사용 시 기본적으로 그 디렉토리의 memory 파일은 로드되지 않는다.
`CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1`을 설정하면 다음을 로드할 수 있다.
- `CLAUDE.md`
- `.claude/CLAUDE.md`
- `.claude/rules/*.md`

단, additional directories의 `CLAUDE.local.md`는 로드되지 않는다.

## 6. exclude
대규모 monorepo에서는 `claudeMdExcludes`로 특정 CLAUDE.md나 rules를 제외할 수 있다.
