# 운영, 보안, 트러블슈팅
문서 ID: CC-CLI-OPS
버전: v1.0.0

## 1. 운영 원칙
- 세션은 이름을 붙여 관리한다.
- 복잡 작업은 plan mode를 우선한다.
- 자동화는 print mode와 json output 중심으로 설계한다.
- 원격/병렬 작업은 worktree 또는 remote-control을 사용한다.

## 2. 보안 원칙
- 완전 우회(`bypassPermissions`)는 제한적으로 사용한다.
- `--tools`, `--disallowedTools`, permission rules로 도구 범위를 줄인다.
- system prompt 전체 교체는 신중히 사용한다.

## 3. 디버깅
- `--debug`
- `--debug-file`
- `--verbose`

## 4. 자주 발생하는 문제
### 4.1 세션을 못 찾음
- 이름 미지정
- 다른 디렉토리/다른 저장소

### 4.2 권한 프롬프트가 너무 많음
- permission mode 검토
- allowedTools / permissions 설정 검토

### 4.3 비대화형 출력이 파이프라인과 안 맞음
- output-format 확인
- json-schema 사용 여부 검토

### 4.4 기본 기능이 사라짐
- `--bare`
- `--disable-slash-commands`
- `--tools` 제한 여부 확인

### 4.5 원격/워크트리 혼선
- 세션 이름 명확화
- worktree별 명시적 네이밍 사용
