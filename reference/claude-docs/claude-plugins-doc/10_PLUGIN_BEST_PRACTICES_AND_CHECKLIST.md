# 10. Plugin 모범 사례와 체크리스트

문서 버전: v1.0.0

## 1. 설계 원칙
### 1.1 작게 시작
처음부터 거대한 plugin을 만들기보다 skill 하나, hook 하나 수준에서 시작한다.

### 1.2 기본 구조 우선
가능하면 기본 디렉토리 구조를 유지한다. 커스텀 path는 꼭 필요할 때만 쓴다.

### 1.3 역할 분리
- skill: 지식/워크플로우
- agent: 전문 역할
- hook: 이벤트 자동화
- MCP: 외부 연결
- LSP: 코드 인텔리전스

### 1.4 side effect 통제
배포, 커밋, 외부 전송처럼 부작용이 큰 skill은 자동 invocation을 막는 편이 안전하다.

## 2. 보안 원칙
- plugin hook은 외부 명령을 실행하므로 신뢰 가능한 코드만 포함한다.
- plugin agent에는 불필요한 권한을 넣지 않는다.
- 민감 정보는 userConfig의 sensitive 필드 또는 환경변수로 분리한다.
- plugin MCP/LSP 경로에는 `${CLAUDE_PLUGIN_ROOT}`를 우선 사용한다.

## 3. 운영 원칙
- 버전과 changelog를 관리한다.
- plugin validate를 릴리즈 전 필수 단계로 둔다.
- README에 prerequisites를 분명히 적는다.
- 팀 공유 plugin은 project scope 또는 marketplace 정책을 정한다.

## 4. 체크리스트
### 4.1 개발 체크리스트
- [ ] plugin.json 작성
- [ ] 기본 구조 준수
- [ ] skill/agent/hook 단위 테스트 완료
- [ ] `/reload-plugins` 반영 확인
- [ ] debug 모드 확인

### 4.2 배포 체크리스트
- [ ] README 작성
- [ ] version 반영
- [ ] CHANGELOG 정리
- [ ] validate 통과
- [ ] install/update/uninstall 검증

### 4.3 팀 운영 체크리스트
- [ ] scope 정책 정의
- [ ] 민감정보 저장 방식 정의
- [ ] prerequisites 문서화
- [ ] fallback/disable 전략 정의

## 5. 최종 권장안
팀장님 관점에서는 다음 흐름이 가장 실용적이다.

1. `.claude/`에서 프로토타입 작성
2. 유효성이 검증되면 plugin으로 승격
3. 팀 공통 기능은 project scope 또는 marketplace 배포
4. 필수 기능은 managed 정책과 결합
