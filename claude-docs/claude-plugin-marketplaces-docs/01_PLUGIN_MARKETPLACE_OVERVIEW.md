# 01. Plugin Marketplace 개요

문서 버전: v1.0.0

## 1. 정의
Plugin Marketplace는 Claude Code 플러그인을 다른 사용자에게 배포하기 위한 카탈로그다. 마켓플레이스는 플러그인 목록, 각 플러그인의 source 위치, 버전 추적, 자동 업데이트의 기준점을 제공한다.

## 2. 왜 필요한가
단일 plugin 디렉터리를 직접 공유하는 방식은 빠르지만, 팀 단위 운영에는 다음 한계가 있다.
- 어떤 플러그인이 공식 배포본인지 식별하기 어렵다.
- 버전과 소스 pinning 관리가 분산된다.
- 여러 plugin을 하나의 카탈로그로 묶어 배포하기 어렵다.
- 설치·업데이트·정책 통제가 불편하다.

Marketplace는 이 문제를 해결하기 위해 중앙 카탈로그 역할을 한다.

## 3. 기본 배포 흐름
1. 플러그인을 만든다.
2. `.claude-plugin/marketplace.json`을 작성한다.
3. GitHub/GitLab/사내 git 또는 로컬 디렉터리에 호스팅한다.
4. 사용자는 `/plugin marketplace add` 또는 `claude plugin marketplace add`로 등록한다.
5. 이후 개별 플러그인을 `plugin@marketplace` 형식으로 설치한다.

## 4. Marketplace와 Plugin의 관계
- **Marketplace**: 플러그인 카탈로그
- **Plugin**: skills, agents, hooks, MCP servers, LSP servers 등을 담는 실제 패키지
- **Marketplace source**: `marketplace.json` 자체를 가져오는 위치
- **Plugin source**: marketplace에 등록된 개별 plugin을 가져오는 위치

두 source는 서로 다를 수 있다. 예를 들어 marketplace는 `acme/plugin-catalog`에 있고, 그 안의 특정 plugin은 `acme/review-plugin` repo에서 가져올 수 있다.

## 5. 실무 적합한 사용 시나리오
- 팀 공통 code review / release / security plugin 배포
- 사내 표준 workflow plugin 카탈로그 운영
- stable / latest 채널 분리
- 컨테이너 이미지에 pre-seeded plugin cache 포함
- managed settings와 결합한 허용 marketplace 제한

## 6. 핵심 운영 원칙
- Marketplace 이름과 plugin 이름은 사용자가 직접 보게 되는 식별자다.
- 팀 공유용은 project scope 또는 managed settings와 함께 쓰는 것이 적합하다.
- 개인 실험용은 local/user scope가 적합하다.
- private repo를 쓰면 수동 설치와 background auto-update 인증 방식이 달라질 수 있다.
