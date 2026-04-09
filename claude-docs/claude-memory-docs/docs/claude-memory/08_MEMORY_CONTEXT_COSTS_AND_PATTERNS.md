# Context 비용과 설계 패턴
문서 ID: CC-MEMORY-COSTS
버전: v1.0.0

## 1. CLAUDE.md의 비용
CLAUDE.md는 세션 시작 시 항상 로드되므로 길수록 컨텍스트 비용이 커진다.

## 2. 운영 원칙
- CLAUDE.md는 200줄 이하 유지 권장
- 상세 참고 자료는 import 또는 rules로 분리
- task-specific instruction은 skills로 이동

## 3. Auto memory의 비용
- `MEMORY.md`의 첫 200줄/25KB만 startup cost 발생
- 세부 topic file은 필요 시 로드되므로 비용이 낮다.

## 4. 설계 패턴
### 4.1 CLAUDE.md는 짧고 강하게
항상 지켜야 할 규칙만 배치

### 4.2 rules로 모듈화
언어별/디렉토리별 규칙 분리

### 4.3 personal info는 local file
팀과 공유하지 않는 정보는 CLAUDE.local.md

### 4.4 반복 워크플로우는 skill로 이동
항상 메모리에 있을 필요 없는 내용은 skill 사용
