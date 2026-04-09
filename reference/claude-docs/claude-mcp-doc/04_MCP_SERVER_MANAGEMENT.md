# 04. MCP 서버 관리

## 1. 기본 관리 명령
```bash
claude mcp list
claude mcp get github
claude mcp remove github
```

## 2. 세션 내 상태 확인
Claude Code 내부에서 다음 명령으로 상태와 인증 상태를 확인한다.

```text
/mcp
```

## 3. 동적 업데이트
MCP 서버가 `list_changed` 알림을 보내면 Claude Code는 도구/프롬프트/리소스를 재조회할 수 있다.

## 4. 운영 점검 항목
- 서버 연결 상태
- 인증 상태
- 툴 목록 갱신 여부
- 출력 과다 여부
- 권한/스코프 충돌 여부

## 5. 문제 발생 시 우선 점검
- URL 또는 명령 경로 오타
- 인증 만료
- 프록시/네트워크 차단
- 로컬 서버 실행 실패
- 프로젝트/로컬/사용자 스코프 충돌
