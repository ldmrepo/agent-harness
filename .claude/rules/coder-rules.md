---
paths:
  - "app/**"
  - "src/**"
  - "tests/**"
---

# Coder Rules

- contract_status가 approved가 아니면 구현을 시작하지 않는다.
- current_task.json의 in_scope에 명시된 범위 내에서만 작업한다.
- 관련 없는 리팩토링, 코드 정리, 주석 추가를 하지 않는다.
- 검증을 실행한 후 결과를 기록한다. 검증 없이 완료를 선언하지 않는다.
- smoke가 실패하면 즉시 구현을 중단하고 복구를 우선한다.
- 세션 종료 전에 claude-progress.txt에 엔트리를 추가한다.
