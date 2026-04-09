# Claude Code Agent Teams 문서 세트

- 문서 버전: v1.0.0
- 작성일: 2026-04-08
- 기준 문서: Claude Code 공식 `Orchestrate teams of Claude Code sessions`
- 목적: Agent teams의 개념, 동작 방식, 구성 요소, 제어 방식, 운영 패턴, 제한사항을 분리 문서로 체계화

## 문서 목록

1. [01_AGENT_TEAMS_OVERVIEW.md](01_AGENT_TEAMS_OVERVIEW.md)
2. [02_AGENT_TEAMS_VS_SUBAGENTS.md](02_AGENT_TEAMS_VS_SUBAGENTS.md)
3. [03_ENABLE_AND_START_AGENT_TEAMS.md](03_ENABLE_AND_START_AGENT_TEAMS.md)
4. [04_TEAM_CONTROL_AND_INTERACTION.md](04_TEAM_CONTROL_AND_INTERACTION.md)
5. [05_AGENT_TEAM_ARCHITECTURE_AND_MECHANICS.md](05_AGENT_TEAM_ARCHITECTURE_AND_MECHANICS.md)
6. [06_TASK_COORDINATION_AND_MESSAGING.md](06_TASK_COORDINATION_AND_MESSAGING.md)
7. [07_AGENT_TEAM_USE_CASES_AND_PATTERNS.md](07_AGENT_TEAM_USE_CASES_AND_PATTERNS.md)
8. [08_AGENT_TEAM_BEST_PRACTICES.md](08_AGENT_TEAM_BEST_PRACTICES.md)
9. [09_AGENT_TEAM_LIMITATIONS_AND_TROUBLESHOOTING.md](09_AGENT_TEAM_LIMITATIONS_AND_TROUBLESHOOTING.md)
10. [10_AGENT_TEAM_OPERATIONS_CHECKLIST.md](10_AGENT_TEAM_OPERATIONS_CHECKLIST.md)

## 빠른 이해 순서

- 처음 읽는 경우: 01 → 02 → 03 → 04
- 설계/구현 관점: 05 → 06 → 07
- 운영/도입 관점: 08 → 09 → 10

## 핵심 요약

Agent teams는 여러 Claude Code 세션을 한 팀으로 묶어 리드 세션이 팀원을 조정하고, 팀원들은 독립된 컨텍스트에서 병렬 작업을 수행하며, 공유 작업 목록과 상호 메시징으로 협업하는 구조이다. 단순 병렬 실행이 아니라 **조정 가능한 다중 세션 시스템**으로 이해해야 한다.
