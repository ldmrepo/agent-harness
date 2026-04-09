# 11. 관리자 제어와 Managed 구성

## 1. managed-mcp.json
관리자는 시스템 경로에 `managed-mcp.json`을 배포하여 MCP 서버 구성을 중앙 통제할 수 있다.

## 2. 두 가지 관리 방식
- 독점 제어: `managed-mcp.json`만 사용, 사용자가 임의 추가 불가
- 정책 제어: allowlist/denylist로 허용 서버 범위만 제한

## 3. allow/deny 기준
각 엔트리는 다음 중 하나로 제한할 수 있다.
- serverName
- serverCommand
- serverUrl

## 4. 동작 원칙
- denylist가 항상 우선한다.
- command/url 제한이 존재하면 stdio 또는 remote 서버는 해당 조건을 만족해야 한다.
- 관리형 파일과 정책 설정은 조직 통제 목적에 적합하다.

## 5. 조직 운영 권장안
- 공용 승인 서버는 managed/project 영역으로 표준화
- 실험 서버는 local/user로 분리
- 외부 공개 서버는 보안 검토 후 allowlist 반영
