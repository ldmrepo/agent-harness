# Claude Code Subagents 문서 세트

문서 버전: v1.0.0  
기준일: 2026-04-08  
기준 문서: Claude Code Docs `Create custom subagents`

## 문서 목적

이 문서 세트는 Claude Code의 subagent 기능을 실무 관점에서 재구성한 분리 문서 모음이다.  
공식 문서의 설명을 바탕으로 다음을 체계적으로 정리한다.

- subagent의 개념과 역할
- built-in subagent와 custom subagent의 차이
- 생성/배치/우선순위/적용 범위
- frontmatter 기반 구성 항목
- tools / permissionMode / mcpServers / skills / hooks / memory / isolation
- foreground/background 실행 방식
- 운영 패턴, 보안 제약, 트러블슈팅

## 문서 목록

1. [01_SUBAGENTS_OVERVIEW.md](01_SUBAGENTS_OVERVIEW.md)
2. [02_BUILTIN_SUBAGENTS.md](02_BUILTIN_SUBAGENTS.md)
3. [03_SUBAGENT_SCOPE_DISCOVERY_AND_PRECEDENCE.md](03_SUBAGENT_SCOPE_DISCOVERY_AND_PRECEDENCE.md)
4. [04_SUBAGENT_FILE_FORMAT_AND_FRONTMATTER.md](04_SUBAGENT_FILE_FORMAT_AND_FRONTMATTER.md)
5. [05_SUBAGENT_TOOLS_PERMISSIONS_AND_MODELS.md](05_SUBAGENT_TOOLS_PERMISSIONS_AND_MODELS.md)
6. [06_SUBAGENT_MEMORY_MCP_SKILLS_AND_HOOKS.md](06_SUBAGENT_MEMORY_MCP_SKILLS_AND_HOOKS.md)
7. [07_SUBAGENT_EXECUTION_MODES_AND_CONTEXT.md](07_SUBAGENT_EXECUTION_MODES_AND_CONTEXT.md)
8. [08_SUBAGENT_WORK_PATTERNS.md](08_SUBAGENT_WORK_PATTERNS.md)
9. [09_SUBAGENT_EXAMPLES_LIBRARY.md](09_SUBAGENT_EXAMPLES_LIBRARY.md)
10. [10_SUBAGENT_OPERATIONS_SECURITY_AND_TROUBLESHOOTING.md](10_SUBAGENT_OPERATIONS_SECURITY_AND_TROUBLESHOOTING.md)

## 읽는 순서

- 처음 보는 경우: 01 → 02 → 03 → 04 → 05
- 실무 적용 목적: 04 → 05 → 06 → 07 → 08 → 09
- 운영/관리 목적: 03 → 06 → 10
