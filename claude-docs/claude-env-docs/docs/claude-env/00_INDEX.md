# Claude Code Environment Variables 문서 세트
문서 ID: CC-ENV-INDEX
버전: v1.0.0
기준일: 2026-04-08

## 목적
본 문서 세트는 Claude Code Environment Variables의 개념, 적용 위치, 분류 체계, 변수군별 세부 설명, 운영 패턴을 표준 문서 형식으로 정리한다.

## 범위
- 환경변수의 역할과 우선순위
- 적용 위치(shell / settings.json env)
- 변수 카테고리 분류
- 인증/라우팅/모델/컨텍스트/쉘/네트워크/MCP/플러그인/관측성/기능 토글 세부 설명
- 운영/보안/트러블슈팅

## 문서 목록
1. 01_ENV_OVERVIEW.md
2. 02_ENV_APPLICATION_MODEL.md
3. 03_ENV_CATEGORIES.md
4. 04_ENV_REFERENCE_AUTH_AND_PROVIDER.md
5. 05_ENV_REFERENCE_MODEL_AND_CONTEXT.md
6. 06_ENV_REFERENCE_SHELL_IO_AND_RUNTIME.md
7. 07_ENV_REFERENCE_MCP_PLUGIN_AND_IDE.md
8. 08_ENV_REFERENCE_NETWORK_MONITORING_AND_SECURITY.md
9. 09_ENV_REFERENCE_FEATURE_TOGGLES_AND_COMPATIBILITY.md
10. 10_ENV_PATTERNS_AND_RECIPES.md
11. 11_ENV_OPERATIONS_SECURITY_TROUBLESHOOTING.md

## 읽기 순서
- 처음 읽는 경우: 01 → 02 → 03
- 운영 담당자: 04 → 06 → 08 → 11
- 성능/비용 담당자: 05 → 06 → 09 → 10
- 빠른 참조: 10
