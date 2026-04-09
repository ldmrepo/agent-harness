# CLAUDE.md와 Rules
문서 ID: CC-EXT-MEMORY-RULES
버전: v1.0.0

## 1. CLAUDE.md의 역할
Claude가 모든 세션에서 알아야 하는 프로젝트 지침을 저장한다.
예:
- 빌드/테스트 명령
- 프로젝트 구조
- 금지 규칙
- 코드 스타일 핵심 원칙

## 2. CLAUDE.md 작성 원칙
- 짧고 구체적으로 작성
- 항상 필요한 내용만 넣기
- 모호한 표현보다 검증 가능한 문장 사용
- 충돌 규칙 제거

## 3. Rules의 역할
`.claude/rules/`는 CLAUDE.md를 세분화하고 경로별/파일별 규칙을 적용한다.

## 4. Rules가 적합한 경우
- 특정 언어/디렉터리 전용 규칙
- 루트 CLAUDE.md를 비대하게 만들고 싶지 않을 때
- 모노레포에서 영역별 지침이 다를 때

## 5. CLAUDE.md와 Rules의 조합
- 루트 CLAUDE.md: 프로젝트 핵심 규칙
- Rules: 세부 파일/경로별 규칙