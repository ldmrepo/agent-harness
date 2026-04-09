# 운영, 디버깅, 트러블슈팅
문서 ID: CC-MEMORY-OPS
버전: v1.0.0

## 1. Claude가 CLAUDE.md를 안 따른다
원인:
- 파일이 로드되지 않음
- 지침이 모호함
- 충돌 지침 존재

조치:
- `/memory`로 로드 여부 확인
- 더 구체적인 문장으로 수정
- 충돌 지침 정리

## 2. auto memory가 뭘 저장했는지 모르겠다
- `/memory`에서 auto memory 폴더 열기
- `MEMORY.md`와 topic files 확인

## 3. CLAUDE.md가 너무 크다
- 200줄 이하로 줄이기
- import 또는 `.claude/rules/`로 분리

## 4. `/compact` 후 지침이 사라진 것 같다
- CLAUDE.md는 compact 이후 재로딩된다.
- 대화 중에만 말한 지침은 사라질 수 있다.

## 5. 운영 원칙
- 행동 지침은 CLAUDE.md
- 기술 강제는 settings/permissions
- 모듈화는 rules
- 자동 학습은 auto memory

## 6. 권장 점검 도구
- `/memory`
- `InstructionsLoaded` hook
- `claudeMdExcludes`
- `--append-system-prompt` (엄격한 자동화용)
