# 통합 및 런타임 관련 플래그
문서 ID: CC-CLI-INTEGRATIONS
버전: v1.0.0

## 1. 도구 및 실행 범위
### 1.1 `--tools`
사용 가능한 built-in tool 제한

### 1.2 `--allowedTools`
permission prompt 없이 실행 가능한 도구 지정

### 1.3 `--disallowedTools`
모델 컨텍스트에서 제거할 도구 지정

### 1.4 `--add-dir`
추가 작업 디렉토리 접근 부여

## 2. 확장 기능
### 2.1 `--mcp-config`
MCP server 설정 로드

### 2.2 `--strict-mcp-config`
오직 지정한 mcp-config만 사용

### 2.3 `--plugin-dir`
세션 한정 plugin directory 로드

### 2.4 `--agent`
세션 agent override

### 2.5 `--agents`
JSON으로 custom subagent 동적 정의

### 2.6 `--disable-slash-commands`
skills/commands 비활성화

## 3. 브라우저/IDE 통합
- `--chrome`
- `--no-chrome`
- `--ide`

## 4. 원격 실행
- `--remote`
- `--teleport`
- `--remote-control`
- `--remote-control-session-name-prefix`

## 5. 병렬/격리 실행
- `--worktree`
- `--tmux`
- `--teammate-mode`
