# 세션 및 권한 관련 플래그
문서 ID: CC-CLI-SESSION-PERMISSIONS
버전: v1.0.0

## 1. 세션 재개
### 1.1 `--continue`, `-c`
현재 디렉토리의 가장 최근 세션 재개

### 1.2 `--resume`, `-r`
세션 이름 또는 ID로 특정 세션 재개

### 1.3 `--fork-session`
기존 세션을 재개하되 새 세션 ID를 만든다.

### 1.4 `--session-id`
특정 UUID를 강제로 사용한다.

### 1.5 `--name`, `-n`
세션 표시 이름을 지정한다.

## 2. 권한 모드
### 2.1 `--permission-mode`
가능 값:
- default
- acceptEdits
- plan
- auto
- dontAsk
- bypassPermissions

### 2.2 `--enable-auto-mode`
auto mode를 Shift+Tab cycle에 활성화한다.

### 2.3 `--dangerously-skip-permissions`
permission prompt를 건너뛴다.

### 2.4 `--allow-dangerously-skip-permissions`
시작 모드는 유지하되 cycle에 bypassPermissions를 추가한다.

### 2.5 `--permission-prompt-tool`
비대화형 모드에서 permission prompt를 처리할 MCP tool을 지정한다.

## 3. 운영 원칙
- 복잡한 작업은 `plan`
- 자동화는 `dontAsk` 또는 `auto`
- 위험한 완전 우회는 `bypassPermissions`
