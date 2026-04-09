# 03. Plugin Source 유형

문서 버전: v1.0.0

## 1. 개요
Marketplace의 각 plugin entry는 `source` 필드로 실제 plugin을 어디서 가져올지 정의한다.

지원되는 주요 source 유형:
- relative path
- github
- url (git repository)
- git-subdir
- npm

## 2. Relative path
```json
{
  "name": "my-plugin",
  "source": "./plugins/my-plugin"
}
```

### 특징
- marketplace 저장소 내부 plugin 디렉터리를 가리킨다.
- 반드시 `./`로 시작해야 한다.
- marketplace root 기준으로 해석된다.
- `../`로 root 밖을 참조하면 안 된다.

### 주의
remote URL로 `marketplace.json` 파일만 직접 배포하는 경우, 상대 경로 plugin source는 정상 동작하지 않을 수 있다.

## 3. GitHub source
```json
{
  "name": "github-plugin",
  "source": {
    "source": "github",
    "repo": "owner/plugin-repo",
    "ref": "v2.0.0",
    "sha": "a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0"
  }
}
```

### 필드
- `repo`: 필수, `owner/repo`
- `ref`: 선택, branch/tag
- `sha`: 선택, full 40-char commit SHA

### 운영 팁
재현성을 높이려면 release tag 또는 commit pinning을 사용한다.

## 4. Git URL source
```json
{
  "name": "git-plugin",
  "source": {
    "source": "url",
    "url": "https://gitlab.com/team/plugin.git",
    "ref": "main"
  }
}
```

### 특징
- GitHub 외 git host 사용 가능
- HTTPS/SSH URL 가능
- `.git` suffix는 선택적인 경우가 있다

## 5. git-subdir
```json
{
  "name": "mono-plugin",
  "source": {
    "source": "git-subdir",
    "url": "https://github.com/acme-corp/monorepo.git",
    "path": "tools/claude-plugin",
    "ref": "v2.0.0"
  }
}
```

### 적합한 경우
- monorepo 내부 하위 디렉터리에 plugin이 있을 때
- 전체 repo clone 비용을 줄이고 싶을 때

### 특징
- sparse/partial clone을 활용해 bandwidth를 줄인다.

## 6. npm source
```json
{
  "name": "my-npm-plugin",
  "source": {
    "source": "npm",
    "package": "@acme/claude-plugin",
    "version": "^2.0.0",
    "registry": "https://npm.example.com"
  }
}
```

### 적합한 경우
- 사내 npm registry 기반 배포
- JS/TS 중심 plugin 배포 파이프라인
- semver range 사용

## 7. source 선택 기준
### same-repo 운영
- relative path

### public open-source 배포
- github

### 사내 git / GitLab / Bitbucket
- url 또는 git-subdir

### 사내 registry 표준화
- npm

## 8. pinning 전략
- 빠른 업데이트: `ref`
- 완전 재현성: `sha`
- channel 운영: stable/latest 등 별도 ref
