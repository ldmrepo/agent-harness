# 05. 호스팅, 배포, Private Repository 운영

문서 버전: v1.0.0

## 1. 권장 호스팅 방식
가장 일반적인 방식은 GitHub repository에 marketplace를 두는 것이다.

### GitHub 예시
```shell
/plugin marketplace add owner/repo
```

### Git URL 예시
```shell
/plugin marketplace add https://gitlab.example.com/team/plugins.git
```

### 직접 URL 예시
```shell
/plugin marketplace add https://example.com/marketplace.json
```

## 2. 호스팅 방식별 특징
### GitHub / git host
- 버전 이력과 협업에 유리
- relative path plugin source 사용이 자연스럽다
- update 흐름이 단순하다

### direct URL
- `marketplace.json` 단일 파일 배포에는 편리
- 하지만 relative path plugin source와 궁합이 좋지 않다

## 3. Private repository
private repo도 사용할 수 있지만 인증 전략을 구분해야 한다.

### 수동 설치/업데이트
- 사용자의 기존 git credential helper 사용
- terminal에서 `git clone`이 되면 Claude Code에서도 보통 동작

### background auto-update
- interactive prompt를 띄울 수 없으므로 token 환경변수 필요 가능
- 예:
  - `GITHUB_TOKEN` / `GH_TOKEN`
  - `GITLAB_TOKEN` / `GL_TOKEN`
  - `BITBUCKET_TOKEN`

## 4. 팀 배포 시 고려사항
- plugin source repo 접근 권한
- CI/CD 또는 container image에서의 seed 전략
- stable/latest 분리 여부
- private registry 또는 internal git host 정책

## 5. 배포 권장 전략
### 소규모 팀
- GitHub repo + project scope

### 사내 공통 도구
- managed settings + extraKnownMarketplaces

### 폐쇄망/컨테이너
- seed directory 사전 탑재

## 6. 파일 복사 모델 주의점
plugin은 설치 시 cache로 복사된다. 따라서 다음 패턴은 깨질 수 있다.
- `../shared-utils`
- plugin 바깥 경로를 전제로 한 script/include
- 상대 경로 기반 외부 의존

필요 시 symlink 또는 plugin 내부 재구성 전략이 필요하다.
