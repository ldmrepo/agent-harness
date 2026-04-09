# Claude Code Hooks 문서 세트
문서 ID: CC-HOOKS-INDEX
버전: v1.1.0
기준일: 2026-04-08

## 목적
본 문서 세트는 Claude Code Hooks의 개념, 동작 방식, 분류 체계, 이벤트별 세부 사양, 운영 패턴을 표준 문서 형식으로 정리한다.

## 범위
- Hooks의 개념 정의
- Hook lifecycle과 실행 모델
- Hook 카테고리 분류
- 설정 스키마와 매처 규칙
- 입력/출력 JSON 구조
- 결정 제어(decision control)와 exit code 의미
- 이벤트별 상세 설명
- command/http/prompt/agent hook 비교
- 보안, 운영, 디버깅, 트러블슈팅
- 프로젝트용 settings.json 및 샘플 hook script 라이브러리

## 문서 목록
1. 01_HOOKS_OVERVIEW.md
2. 02_HOOK_LIFECYCLE_AND_EXECUTION.md
3. 03_HOOK_CATEGORIES.md
4. 04_HOOK_CONFIGURATION_SCHEMA.md
5. 05_HOOK_EVENT_REFERENCE_CORE.md
6. 06_HOOK_EVENT_REFERENCE_EXTENDED.md
7. 07_HOOK_TYPES_COMMAND_HTTP_PROMPT_AGENT.md
8. 08_HOOK_IO_DECISIONS_AND_EXIT_CODES.md
9. 09_HOOK_PATTERNS_AND_RECIPES.md
10. 10_HOOK_OPERATIONS_SECURITY_TROUBLESHOOTING.md
11. 11_HOOK_SETTINGS_EXAMPLE.md
12. 12_HOOK_SCRIPT_LIBRARY.md
13. 13_HOOK_ROLLOUT_POLICY.md

## 읽기 순서
- 처음 읽는 경우: 01 → 02 → 03 → 04
- 구현 담당자: 04 → 07 → 08 → 09 → 11 → 12
- 운영/보안 담당자: 03 → 08 → 10 → 13
- 레퍼런스 확인: 05 → 06
