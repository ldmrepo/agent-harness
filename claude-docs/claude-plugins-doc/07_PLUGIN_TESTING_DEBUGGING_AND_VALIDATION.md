# 07. Plugin 테스트, 디버깅, 검증

문서 버전: v1.0.0

## 1. 테스트 기본 순서
1. `--plugin-dir`로 로컬 로드
2. `/reload-plugins`로 변경 반영
3. skill 호출 테스트
4. `/agents`에서 agent 노출 확인
5. hook 이벤트 발생 확인
6. MCP/LSP 서버 초기화 확인

## 2. 디버그 모드
```bash
claude --debug
```

확인 가능한 항목:
- 어떤 plugin이 로딩되는지
- manifest 에러
- command/agent/hook 등록
- MCP 서버 초기화 상태

## 3. 자주 쓰는 검증 포인트
### 3.1 구조 오류
가장 흔한 실수는 `commands/`, `skills/`, `agents/`, `hooks/`를 `.claude-plugin/` 안에 넣는 것이다.

### 3.2 manifest 오류
- JSON 문법 에러
- name 누락
- 잘못된 경로 지정

### 3.3 hook 미동작
- 스크립트 실행 권한 없음
- shebang 누락
- 잘못된 matcher
- event 이름 오타

### 3.4 MCP 오류
- `${CLAUDE_PLUGIN_ROOT}` 미사용
- 잘못된 서버 경로
- 필요한 환경변수 미설정

### 3.5 LSP 오류
- 언어 서버 바이너리 미설치
- PATH에서 실행 불가

## 4. 검증 명령
공식 reference 기준으로 다음 검증 도구를 활용할 수 있다.
- `claude plugin validate`
- `/plugin validate`

## 5. 대표 오류와 해석
### 5.1 Plugin not loading
원인: `plugin.json` 문제  
대응: JSON/스키마 검증

### 5.2 Commands not appearing
원인: 디렉토리 구조 오류  
대응: `commands/`가 루트에 있는지 확인

### 5.3 Hooks not firing
원인: 실행 권한 없음 또는 matcher 문제  
대응: `chmod +x`, event/matcher 점검

### 5.4 MCP server fails
원인: plugin root 변수 미사용 또는 경로 문제  
대응: `${CLAUDE_PLUGIN_ROOT}` 사용

## 6. 실무 테스트 체크리스트
- [ ] plugin name 충돌 여부 확인
- [ ] 설치/비설치 두 방식 모두 테스트
- [ ] `/reload-plugins` 반영 여부 확인
- [ ] plugin 비활성화 후 정상 제거 확인
- [ ] persistent data 유지 정책 검토
