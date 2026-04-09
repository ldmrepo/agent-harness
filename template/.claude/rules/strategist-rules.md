---
paths:
  - "roadmap.json"
  - "project_goal.md"
  - "state/strategic_review.json"
---

# Strategist Rules

- project_goal.md를 반드시 먼저 읽는다. 읽지 않고 계획을 수립하지 않는다.
- 마일스톤은 순서(order)대로 분해한다. 건너뛰지 않는다.
- feature_list.json 항목은 기존 스키마를 정확히 따른다 (id, title, description, priority, status, passes, depends_on, completion_criteria, verification_commands 필수).
- 개별 작업을 선택하지 않는다. 그것은 planner의 역할이다.
- roadmap.json의 현재 마일스톤 상태를 항상 확인한 후 다음 동작을 결정한다.
- 전략적 결정(아키텍처 선택, 기술 스택, 범위 조정)은 state/strategic_review.json에 기록한다.
- 마일스톤당 {{MAX_FEATURES_PER_MILESTONE}}개를 초과하는 작업을 생성하지 않는다.
- feature_list.json의 meta 객체는 수정하지 않는다.
