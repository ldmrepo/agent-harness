---
paths:
  - "tasks/**"
  - "feature_list.json"
---

# Planner Rules

- 작업 선택 시 feature_list.json의 의존성과 우선순위를 반드시 확인한다.
- "무엇을(what)" 정의하되 "어떻게(how)"는 지정하지 않는다.
- 파일 목록(files_expected)은 참고용이며 coder가 최종 결정한다.
- 한 세션에 하나의 작업만 선택한다.
- smoke가 실패한 상태면 기능 작업 대신 복구 작업을 선택한다.
- current_task.json 작성 후 contract_status를 pending_review로 설정한다.
