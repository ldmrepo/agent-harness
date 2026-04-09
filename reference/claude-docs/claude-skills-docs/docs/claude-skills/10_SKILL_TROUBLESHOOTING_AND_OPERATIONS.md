# Skills 운영과 트러블슈팅

## 1. Skill이 자동으로 안 뜨는 경우

점검 순서:
1. description에 자연어 키워드가 있는지 확인
2. `What skills are available?`로 노출 확인
3. 요청 문구를 description과 더 가깝게 조정
4. `/skill-name`으로 직접 호출 테스트

## 2. 너무 자주 트리거되는 경우

대응:
- description 더 구체화
- `disable-model-invocation: true` 적용 검토

## 3. Description 잘림 문제

skill descriptions는 context budget 제약을 받는다.
핵심 사항:
- skill names는 항상 포함
- description은 budget에 맞게 축약될 수 있음
- 각 entry는 250자 cap 영향을 받음

대응:
- 핵심 use case를 맨 앞에 배치
- description 압축
- 필요 시 `SLASH_COMMAND_TOOL_CHAR_BUDGET` 조정

## 4. Shell execution 정책 문제

`disableSkillShellExecution: true` 설정 여부 확인

## 5. Subagent 결과가 빈약한 경우

원인:
- `context: fork` skill에 실행 task가 없음
- 참고 지침만 있고 명령형 task가 없음

대응:
- 명시적 단계 추가
- 목표/출력 형식/검증 기준 추가

## 6. 운영 체크리스트

- name 충돌 여부 확인
- description 키워드 점검
- side effect skill은 수동 호출화
- supporting files 링크 점검
- allowed-tools 최소화
- paths 조건 검증
- examples와 scripts 최신화 유지

## 7. 권장 운영 원칙

- 지식형과 실행형 skill 분리
- 대형 문서는 supporting files로 이동
- side effect 있는 skill은 자동 호출 금지
- monorepo는 nested skills 적극 활용
