# 05. Plugin Manifest Schema

문서 버전: v1.0.0

## 1. 위치
플러그인 매니페스트는 `.claude-plugin/plugin.json`에 둔다.

## 2. manifest의 의미
manifest는 플러그인의 이름, 버전, 설명, 작성자, 그리고 컴포넌트 경로를 정의하는 메타데이터 파일이다.

공식 문서 기준으로 manifest는 선택 사항이다.  
없어도 기본 위치를 기준으로 컴포넌트를 자동 발견할 수 있다.  
하지만 배포·식별·커스텀 경로 설정을 위해서는 manifest 작성이 권장된다.

## 3. 핵심 필드
### 3.1 필수
- `name`

### 3.2 주요 메타데이터
- `version`
- `description`
- `author`
- `homepage`
- `repository`
- `license`
- `keywords`

### 3.3 컴포넌트 경로
- `commands`
- `agents`
- `skills`
- `hooks`
- `mcpServers`
- `outputStyles`
- `lspServers`

## 4. 예시
```json
{
  "name": "plugin-name",
  "version": "1.2.0",
  "description": "Brief plugin description",
  "author": {
    "name": "Author Name",
    "email": "author@example.com",
    "url": "https://github.com/author"
  },
  "homepage": "https://docs.example.com/plugin",
  "repository": "https://github.com/author/plugin",
  "license": "MIT",
  "keywords": ["deployment", "ci-cd"],
  "commands": ["./custom/commands/special.md"],
  "agents": "./custom/agents/",
  "skills": "./custom/skills/",
  "hooks": "./config/hooks.json",
  "mcpServers": "./mcp-config.json",
  "outputStyles": "./styles/",
  "lspServers": "./.lsp.json"
}
```

## 5. userConfig
`userConfig`는 플러그인 활성화 시 사용자에게 값을 입력받기 위한 선언이다.

예:
```json
{
  "userConfig": {
    "api_endpoint": {
      "description": "Your team's API endpoint",
      "sensitive": false
    },
    "api_token": {
      "description": "API authentication token",
      "sensitive": true
    }
  }
}
```

### 5.1 목적
- 사용자에게 직접 `settings.json` 편집을 요구하지 않음
- 민감값과 비민감값을 구분
- 플러그인 내부 설정 치환에 활용

### 5.2 치환
- `${user_config.KEY}` 형태로 사용할 수 있다.
- 민감값은 keychain 또는 credentials 저장소에 보관된다.
- 비민감값은 설정 파일에 저장된다.

## 6. channels
공식 reference에는 `channels` 필드도 존재한다. 이는 메시지 주입형 채널 선언용이다. 채널형 플러그인 설계 시 별도 검토가 필요하다.

## 7. 주의사항
- name은 kebab-case 권장
- 절대 경로보다 상대 경로를 사용
- 경로 규칙을 커스텀하면 배포 후 구조 혼동이 커질 수 있으므로 기본 구조 우선
