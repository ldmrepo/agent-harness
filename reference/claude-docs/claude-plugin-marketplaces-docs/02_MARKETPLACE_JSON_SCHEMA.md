# 02. marketplace.json 스키마

문서 버전: v1.0.0

## 1. 파일 위치
Marketplace 카탈로그 파일은 일반적으로 저장소 루트의 다음 위치에 둔다.

```text
<repo>/.claude-plugin/marketplace.json
```

## 2. 최상위 필수 필드
```json
{
  "name": "company-tools",
  "owner": {
    "name": "DevTools Team",
    "email": "devtools@example.com"
  },
  "plugins": []
}
```

### 필드 설명
- `name`: marketplace 식별자. kebab-case 권장
- `owner`: 유지관리자 정보
- `plugins`: plugin entry 배열

## 3. owner 필드
```json
{
  "owner": {
    "name": "DevTools Team",
    "email": "devtools@example.com"
  }
}
```

- `name`: 필수
- `email`: 선택

## 4. metadata 필드
```json
{
  "metadata": {
    "description": "Internal productivity plugins",
    "version": "1.2.0",
    "pluginRoot": "./plugins"
  }
}
```

### 의미
- `metadata.description`: marketplace 설명
- `metadata.version`: marketplace 자체 버전
- `metadata.pluginRoot`: 상대 plugin source 경로의 공통 prefix

## 5. plugin entry 최소 형태
```json
{
  "name": "quality-review-plugin",
  "source": "./plugins/quality-review-plugin"
}
```

## 6. plugin entry 확장 형태
```json
{
  "name": "enterprise-tools",
  "source": {
    "source": "github",
    "repo": "company/enterprise-plugin"
  },
  "description": "Enterprise workflow automation tools",
  "version": "2.1.0",
  "author": {
    "name": "Enterprise Team",
    "email": "enterprise@example.com"
  },
  "homepage": "https://docs.example.com/plugins/enterprise-tools",
  "repository": "https://github.com/company/enterprise-plugin",
  "license": "MIT",
  "keywords": ["enterprise", "workflow"],
  "category": "productivity",
  "tags": ["internal", "release"],
  "strict": false
}
```

## 7. 추가 가능한 구성 필드
Plugin entry에는 manifest 메타데이터 외에도 component 경로/설정을 직접 담을 수 있다.
- `commands`
- `agents`
- `hooks`
- `mcpServers`
- `lspServers`

이는 plugin repo의 `plugin.json`과 marketplace entry 사이의 책임 분배에 영향을 준다.

## 8. strict 모드
### `strict: true` (기본)
- plugin의 `plugin.json`이 권위 있는 정의
- marketplace entry는 보완/추가 역할

### `strict: false`
- marketplace entry가 전체 정의
- plugin 쪽 `plugin.json`에 component 선언이 있으면 충돌 가능
- 운영자가 plugin 노출 범위를 통제할 때 유용

## 9. 명명 규칙
- marketplace name과 plugin name은 public-facing identifier다.
- kebab-case 권장
- 공식 Anthropic marketplace로 오해될 수 있는 reserved/impersonating name은 피해야 한다.
