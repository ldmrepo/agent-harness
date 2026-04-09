# 06. Plugin 설치 스코프와 CLI

문서 버전: v1.0.0

## 1. 설치 스코프
플러그인은 scope에 따라 적용 범위가 달라진다.

| 스코프 | 저장 위치 | 용도 |
|---|---|---|
| user | `~/.claude/settings.json` | 개인 공용 플러그인 |
| project | `.claude/settings.json` | 팀 공유 플러그인 |
| local | `.claude/settings.local.json` | gitignored 프로젝트 전용 |
| managed | 관리 설정 | 조직 관리형 플러그인 |

## 2. 언제 어떤 스코프를 쓰는가
### 2.1 user
개인이 여러 프로젝트에서 공통으로 쓰는 플러그인

### 2.2 project
팀 전체가 같은 플러그인을 써야 할 때

### 2.3 local
현재 프로젝트에서만 개인적으로 테스트할 때

### 2.4 managed
조직이 강제 배포·관리할 때

## 3. 주요 CLI 명령
### 3.1 install
```bash
claude plugin install <plugin>
claude plugin install formatter@my-marketplace --scope project
```

### 3.2 uninstall
```bash
claude plugin uninstall <plugin>
claude plugin uninstall formatter@my-marketplace --scope local --keep-data
```

### 3.3 enable / disable
```bash
claude plugin enable <plugin>
claude plugin disable <plugin>
```

### 3.4 update
```bash
claude plugin update <plugin>
```

## 4. 개발용 로딩
설치 없이 테스트할 때:
```bash
claude --plugin-dir ./my-plugin
```

여러 개도 가능하다.
```bash
claude --plugin-dir ./plugin-one --plugin-dir ./plugin-two
```

## 5. reload
개발 중 파일 수정 후:
```text
/reload-plugins
```

이 명령은 plugins, skills, agents, hooks, plugin MCP servers, plugin LSP servers를 다시 로드한다.

## 6. precedence 메모
개발 중 `--plugin-dir`로 로드한 플러그인이 설치된 같은 이름의 marketplace plugin보다 우선할 수 있다. 다만 managed settings로 강제된 plugin은 예외다.
