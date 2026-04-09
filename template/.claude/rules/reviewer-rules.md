---
paths:
  - "state/**"
  - "verification/**"
---

# Reviewer Rules

- 증거 기반으로만 판단한다. "아마 괜찮을 것"은 승인 사유가 아니다.
- 판단이 애매하면 [QA-UNCERTAIN]을 기록한다.
- 증거 부족한데 승인하려는 유혹이 있으면 [QA-RATIONALIZATION-RISK]를 기록한다.
- 범위 준수를 가장 먼저 확인한다. 범위 밖 변경은 즉시 반려한다.
- 런타임 검증이 가능하면 실행 중인 앱을 직접 테스트한다.
- 놓친 이슈가 발견되면 state/qa_tuning_log.json에 기록한다.
