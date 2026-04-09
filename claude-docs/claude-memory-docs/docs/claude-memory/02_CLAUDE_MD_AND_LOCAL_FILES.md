# CLAUDE.md / CLAUDE.local.md
문서 ID: CC-MEMORY-CLAUDE-MD
버전: v1.0.0

## 1. CLAUDE.md의 역할
CLAUDE.md는 프로젝트, 사용자, 조직 수준의 지속 지침을 담는 마크다운 파일이다. Claude는 세션 시작 시 이를 읽고 작업 기준으로 사용한다.

## 2. 배치 위치와 범위
### 2.1 Managed policy
- macOS: `/Library/Application Support/ClaudeCode/CLAUDE.md`
- Linux/WSL: `/etc/claude-code/CLAUDE.md`
- Windows: `C:\Program Files\ClaudeCode\CLAUDE.md`

### 2.2 Project instructions
- `./CLAUDE.md`
- `./.claude/CLAUDE.md`

### 2.3 User instructions
- `~/.claude/CLAUDE.md`

### 2.4 Local instructions
- `./CLAUDE.local.md`
- 개인 프로젝트 전용 선호도용
- `.gitignore` 추가 권장

## 3. CLAUDE.local.md의 특징
- project root에 두는 개인 프로젝트 전용 지침
- 팀과 공유하지 않는 sandbox URL, 개인 test data, 로컬 선호도에 적합
- 같은 디렉토리에서는 `CLAUDE.md` 뒤에 append되어 읽힌다.

## 4. 효과적인 작성 원칙
- 200줄 이하 권장
- 헤더/불릿으로 구조화
- 모호한 표현보다 검증 가능한 표현 사용
- 충돌 지침 제거

## 5. 예시
```md
# Build
- Use pnpm instead of npm
- Run `pnpm test` before commit

# Architecture
- API handlers live in `src/api/handlers/`
```
