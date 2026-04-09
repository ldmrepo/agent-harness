# 09. 검증과 문제해결

문서 버전: v1.0.0

## 1. 검증 명령
### CLI
```bash
claude plugin validate .
```

### interactive
```shell
/plugin validate .
```

## 2. 무엇을 검증하나
- `marketplace.json`
- plugin `plugin.json`
- skill / agent / command frontmatter
- `hooks/hooks.json`

## 3. 대표 오류와 해석
### marketplace.json 없음
```text
File not found: .claude-plugin/marketplace.json
```
대응: marketplace 파일 생성

### JSON syntax 오류
```text
Invalid JSON syntax: Unexpected token...
```
대응: trailing comma, quote, brace 확인

### duplicate plugin name
```text
Duplicate plugin name "x" found in marketplace
```
대응: plugin name 유일성 보장

### 상대 경로에 `..` 포함
```text
plugins[0].source: Path contains ".."
```
대응: marketplace root 밖 참조 제거

### frontmatter parse 실패
```text
YAML frontmatter failed to parse: ...
```
대응: YAML block 수정

## 4. 대표 운영 문제
### URL 기반 marketplace에서 relative path plugin 실패
원인:
- `marketplace.json` 파일만 받았고 plugin 디렉터리는 받지 못함

대응:
- github/url/git-subdir/npm source로 전환
- 또는 marketplace 자체를 git 기반으로 배포

### private repo 인증 실패
대응:
- git credential helper 확인
- manual clone 성공 여부 확인
- background auto-update용 token 환경변수 설정

### git operation timeout
대응:
```bash
export CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS=300000
```

### offline 환경에서 marketplace update 실패
대응:
```bash
export CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE=1
```
또는 seed directory 사용

## 5. 운영 점검 루틴
- validate 통과
- add/install/update/remove 동작 점검
- private repo 인증 리허설
- relative path 의존성 점검
- plugin cache 복사 모델에 따른 경로 깨짐 여부 확인
