# Claude Code Memory 개요
문서 ID: CC-MEMORY-OVERVIEW
버전: v1.0.0

## 1. 정의
Claude Code의 프로젝트 기억 기능은 세션 간 지식 전달을 위한 두 축으로 구성된다.
- **CLAUDE.md 계열 파일**: 사용자가 작성하는 지속 지침
- **Auto memory**: Claude가 스스로 기록하는 학습 노트

## 2. 핵심 개념
Claude Code의 각 세션은 새로운 컨텍스트 윈도우로 시작하지만, 시작 시점에 memory 관련 정보가 다시 로드된다.
- CLAUDE.md / CLAUDE.local.md / `.claude/rules/`는 사용자·프로젝트·조직 지침을 제공한다.
- Auto memory는 이전 세션에서 축적된 build command, debugging insight, preference, workflow habit 등을 재활용한다.

## 3. 역할 구분
### 3.1 CLAUDE.md 계열
- 작성자: 사용자 또는 조직
- 용도: 코딩 표준, 테스트 규칙, 아키텍처, 반복 규칙
- 성격: 명시적 지침

### 3.2 Auto memory
- 작성자: Claude
- 용도: 자주 반복되는 수정 사항, 디버깅 학습, 선호도, 빌드 습관
- 성격: 축적된 학습

## 4. 운영 관점 요약
- 항상 지켜야 할 규칙은 CLAUDE.md 또는 rules에 둔다.
- 세션 중 얻은 학습을 자동 축적하게 하려면 auto memory를 켠다.
- 둘 다 컨텍스트로 취급되며, 강제 설정이 아니다.
