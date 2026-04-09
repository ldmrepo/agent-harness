# 02. Plugins vs Standalone 구성

문서 버전: v1.0.0

## 1. 두 방식의 차이
Claude Code는 확장을 넣는 방법으로 크게 두 가지를 지원한다.

### 1.1 Standalone
프로젝트의 `.claude/` 아래에 직접 skills, agents, commands, settings 등을 넣는 방식이다.

### 1.2 Plugin
플러그인 디렉토리 안에 확장 요소를 넣고, 이를 설치 또는 `--plugin-dir`로 로드하는 방식이다.

## 2. 비교
| 항목 | Standalone | Plugin |
|---|---|---|
| skill 이름 | `/hello` | `/plugin-name:hello` |
| 주 용도 | 개인 실험, 단일 프로젝트 | 팀 공유, 재사용, 배포 |
| 버전 관리 | 프로젝트 수준 | 플러그인 버전 중심 |
| 설치/업데이트 | 수동 복사 중심 | plugin install/update 가능 |
| 충돌 방지 | 상대적으로 약함 | 네임스페이스 기반으로 강함 |

## 3. Standalone이 적합한 경우
- 특정 프로젝트에서만 쓰는 규칙
- 개인 워크플로우 실험
- 빠르게 시도해보는 초기 아이디어
- 짧은 명령 이름이 중요한 경우

## 4. Plugin이 적합한 경우
- 여러 프로젝트에서 동일한 기능이 필요한 경우
- 팀원과 같은 확장을 공유해야 하는 경우
- 마켓플레이스 배포를 고려하는 경우
- 업데이트, enable/disable, scope 관리가 필요한 경우

## 5. 추천 전략
1. 먼저 `.claude/`에서 빠르게 실험한다.
2. 재사용 가치가 생기면 Plugin으로 승격한다.
3. 팀 표준이 되면 marketplace 또는 관리형 배포로 확장한다.
