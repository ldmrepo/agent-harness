# 기능별 역할 매트릭스
문서 ID: CC-EXT-FEATURE-MATRIX
버전: v1.0.0

## 1. 요약 표
| 기능 | 핵심 역할 | 적합한 용도 | 대표 예시 |
|---|---|---|---|
| CLAUDE.md | 항상 로드되는 지속 지침 | 프로젝트 규칙, 빌드/테스트 규칙 | "pnpm 사용", "커밋 전 테스트" |
| Rules | 조건부/경로별 규칙 | 언어/디렉터리별 지침 | `src/api/**/*.ts` 전용 규칙 |
| Skill | 재사용 가능한 지식/워크플로우 | 참조 문서, 반복 작업 | `/deploy`, API 스타일 가이드 |
| Subagent | 격리된 작업 실행 | 많은 파일 탐색, 병렬 검토 | 연구, 코드 리뷰 |
| Agent team | 독립 세션 협업 | 경쟁 가설, 역할 분업 | 보안/성능/테스트 병렬 검토 |
| MCP | 외부 서비스 연결 | DB/Slack/브라우저/사내 도구 | DB 질의, Slack 알림 |
| Hook | 이벤트 기반 자동화 | lint, guardrail, 알림 | 수정 후 ESLint 실행 |
| Plugin | 기능 묶음 배포 | 여러 저장소 재사용/배포 | skill + hook + agent + MCP bundle |
| Marketplace | plugin 유통 | 조직/커뮤니티 배포 | 공식/사내 플러그인 카탈로그 |

## 2. 선택 원칙
- "항상 알아야 한다" → CLAUDE.md
- "가끔 필요하고 재사용한다" → Skill
- "외부 시스템에 연결한다" → MCP
- "작업을 격리해 요약만 받는다" → Subagent
- "서로 상호작용하는 병렬 세션이 필요하다" → Agent team
- "이벤트 발생 시 자동 실행" → Hook
- "여러 기능을 묶어 배포한다" → Plugin