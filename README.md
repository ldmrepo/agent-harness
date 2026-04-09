# Agent Harness

장시간 코딩 에이전트(Claude Code 등)의 멀티세션 운영을 위한 템플릿 기반 하네스 시스템.

Anthropic의 [Harness Design for Long-Running Application Development](https://www.anthropic.com/engineering/harness-design-long-running-apps) 원칙에 기반.

## 프로젝트 구조

```
agent-harness/
│
├── template/                ← 신규 프로젝트에 복사하는 하네스 템플릿
│   ├── AGENTS.md            운영 정책
│   ├── init.sh              부트스트랩 진입점
│   ├── orchestrator.sh      자동 세션 순환
│   ├── configure.sh         변수 치환 도구
│   ├── .claude/             에이전트, 스킬, 훅, 규칙
│   ├── scripts/             공통 유틸, 부트스트랩, 커밋, 롤백
│   ├── state/               상태 파일 템플릿
│   ├── tasks/               작업 관리 템플릿
│   ├── verification/        스모크, 전체 검증
│   └── docs/                아키텍처, 런북, 품질 게이트
│
├── specs/                   ← 하네스 설계 표준 (한국어)
│   ├── long_running_agent_harness.md
│   └── long_running_agent_harness_variable_dictionary.md
│
├── research/                ← 분석/연구/계획
│   ├── long_term_autonomous_analysis.md
│   └── plans/
│
├── reference/               ← 외부 참조 문서
│   └── claude-docs/         Claude Code 기능 문서
│
├── USAGE_GUIDE.md           ← 하네스 적용 가이드
└── README.md                ← 이 파일
```

## 폴더 용도

| 폴더 | 용도 | 대상 |
|------|------|------|
| `template/` | 신규 프로젝트에 `cp -r template/ my-project/`로 복사 | 하네스 사용자 |
| `specs/` | 하네스 설계 표준 문서 (한국어) | 하네스 개발자/유지보수자 |
| `research/` | 분석, 개발 계획, 실험 | 하네스 개발자 |
| `reference/` | Claude Code 기능 참조 문서 | 하네스 개발자 |

## 신규 프로젝트에 적용하기

```bash
# 1. 템플릿 복사
cp -r template/ /path/to/my-project/
cd /path/to/my-project/

# 2. 변수 치환 (대화형)
bash configure.sh --interactive

# 3. 부트스트랩 + 검증
bash ./init.sh
bash ./verification/smoke.sh
```

상세 가이드: [USAGE_GUIDE.md](USAGE_GUIDE.md)

## 주요 문서

| 문서 | 설명 |
|------|------|
| [USAGE_GUIDE.md](USAGE_GUIDE.md) | 하네스 적용 및 운영 가이드 |
| [표준 문서](specs/long_running_agent_harness.md) | 하네스 설계 표준 (한국어) |
| [변수 사전](specs/long_running_agent_harness_variable_dictionary.md) | 170+개 변수 정의 (한국어) |
| [장기 자율 분석](research/long_term_autonomous_analysis.md) | 장기 자율 실행 분석 |
