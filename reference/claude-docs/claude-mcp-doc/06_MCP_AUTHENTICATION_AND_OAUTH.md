# 06. 인증과 OAuth

## 1. 일반 원격 인증
원격 HTTP MCP 서버는 OAuth 2.0 인증을 사용할 수 있다. 일반적인 흐름은 다음과 같다.
1. 서버 추가
2. Claude Code에서 `/mcp` 실행
3. 브라우저 로그인 완료
4. 토큰 저장 및 자동 갱신

## 2. 고정 callback 포트
사전 등록된 redirect URI가 필요한 서버는 `--callback-port`를 사용한다.

```bash
claude mcp add --transport http --callback-port 8080 my-server https://mcp.example.com/mcp
```

## 3. 사전 구성 OAuth 자격증명
동적 등록이 안 되는 서버는 `--client-id`, `--client-secret` 방식으로 추가한다.

```bash
claude mcp add --transport http \
  --client-id your-client-id --client-secret --callback-port 8080 \
  my-server https://mcp.example.com/mcp
```

## 4. auth metadata 우회
기본 discovery가 실패하면 `authServerMetadataUrl`을 `oauth` 객체 안에 지정할 수 있다.

## 5. 비 OAuth 인증
`headersHelper`로 접속 시점마다 동적 헤더를 생성할 수 있다. 사내 SSO, Kerberos, 짧은 만료 토큰에 적합하다.

## 6. 실무 체크포인트
- 브라우저가 안 열리면 수동 URL 복사
- 리다이렉트 실패 시 callback URL 수동 입력
- client secret은 보안 저장소에 관리
