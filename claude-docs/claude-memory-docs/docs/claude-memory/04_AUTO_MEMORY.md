# Auto memory
문서 ID: CC-MEMORY-AUTO
버전: v1.0.0

## 1. 정의
Auto memory는 Claude가 세션 간에 유용한 학습을 스스로 축적하는 기능이다.

## 2. 저장하는 정보 예시
- build 명령
- debugging insight
- architecture note
- code style preference
- workflow habit

## 3. 활성화/비활성화
- 기본값: enabled
- `/memory`에서 토글 가능
- project settings의 `autoMemoryEnabled`로 제어 가능
- 환경변수 `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`로 비활성화 가능

## 4. 저장 위치
기본 위치:
```text
~/.claude/projects/<project>/memory/
├── MEMORY.md
├── debugging.md
├── api-conventions.md
└── ...
```

## 5. 작동 방식
- `MEMORY.md`의 처음 200줄 또는 25KB 중 먼저 도달하는 범위만 세션 시작 시 로드
- 자세한 내용은 별도 topic file로 분리
- topic file은 필요 시 표준 파일 도구로 읽음

## 6. 공유 범위
- 같은 git repo 내 worktree와 subdirectory는 하나의 auto memory 디렉토리 공유
- 머신 로컬 저장소이며 다른 머신/클라우드 환경과 자동 공유되지 않음

## 7. 편집/감사
- plain markdown이므로 수동 편집 가능
- `/memory`로 열람, 편집, 삭제 가능
