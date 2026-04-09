# Skills와 Subagents
문서 ID: CC-EXT-SKILLS-SUBAGENTS
버전: v1.0.0

## 1. Skills
Skill은 markdown 기반의 지식/워크플로우 자산이다.
- 참조형: 문서, 규칙, API 설명
- 실행형: `/deploy`, `/review`, `/audit`

## 2. Skill 설계 원칙
- description은 명확히 작성
- side effect가 있는 skill은 `disable-model-invocation: true` 고려
- 재사용 가능한 단위로 작게 쪼개기

## 3. Subagents
Subagent는 별도 컨텍스트를 가진 작업자이다.
- 많은 파일 탐색
- 광범위한 검색
- 병렬 작업
- 역할 특화

## 4. Skill과 Subagent 결합
- Subagent가 특정 skill을 preload
- Skill이 forked context에서 실행
- `/audit`가 여러 subagent를 호출하는 패턴 가능

## 5. 선택 기준
- 결과보다 중간 과정도 메인 컨텍스트에 남겨야 함 → Skill
- 중간 탐색은 숨기고 결과만 원함 → Subagent