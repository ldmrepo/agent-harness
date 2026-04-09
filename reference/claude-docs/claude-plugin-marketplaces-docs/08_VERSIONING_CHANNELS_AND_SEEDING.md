# 08. 버전, 채널, Seed Directory 운영

문서 버전: v1.0.0

## 1. 버전의 위치
plugin version은 두 군데에서 나타날 수 있다.
- plugin manifest `plugin.json`
- marketplace entry `marketplace.json`

가능하면 이중 선언은 피하는 것이 좋다. 일반적으로:
- relative-path plugin: marketplace entry version 사용 가능
- 외부 plugin source: plugin manifest version 사용이 자연스럽다

## 2. stable / latest 채널 설계
동일 plugin에 대해 서로 다른 ref를 가리키는 두 marketplace를 만들면 release channel 운영이 가능하다.

### stable 예시
```json
{
  "name": "stable-tools",
  "plugins": [
    {
      "name": "code-formatter",
      "source": {
        "source": "github",
        "repo": "acme-corp/code-formatter",
        "ref": "stable"
      }
    }
  ]
}
```

### latest 예시
```json
{
  "name": "latest-tools",
  "plugins": [
    {
      "name": "code-formatter",
      "source": {
        "source": "github",
        "repo": "acme-corp/code-formatter",
        "ref": "latest"
      }
    }
  ]
}
```

## 3. 중요 제약
서로 다른 ref라도 plugin manifest version이 동일하면 Claude Code가 동일 버전으로 간주해 update를 건너뛸 수 있다.  
즉, 채널별 ref/commit마다 manifest version도 달라져야 한다.

## 4. Seed directory
컨테이너/CI 환경에서는 `CLAUDE_CODE_PLUGIN_SEED_DIR`로 plugin과 marketplace cache를 사전 탑재할 수 있다.

### 구조
```text
$CLAUDE_CODE_PLUGIN_SEED_DIR/
  known_marketplaces.json
  marketplaces/<name>/...
  cache/<marketplace>/<plugin>/<version>/...
```

## 5. Seed의 특징
- read-only
- startup 시 seed를 primary config에 반영
- plugin cache를 재-clone 없이 사용
- auto-update는 비활성일 수 있음
- seed 항목은 일반 remove/update보다 우선 보호된다

## 6. 실무 권장 시나리오
### 컨테이너 이미지
- build 단계에서 marketplace add / plugin install 수행
- 결과 디렉터리를 이미지에 포함
- runtime에는 seed directory로 읽기만 수행

### 폐쇄망
- 외부 git pull 실패 가능성 최소화
- seed + keep-marketplace-on-failure 전략 병행

## 7. 관련 환경변수
- `CLAUDE_CODE_PLUGIN_SEED_DIR`
- `CLAUDE_CODE_PLUGIN_CACHE_DIR`
- `CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE`
- `CLAUDE_CODE_PLUGIN_GIT_TIMEOUT_MS`
