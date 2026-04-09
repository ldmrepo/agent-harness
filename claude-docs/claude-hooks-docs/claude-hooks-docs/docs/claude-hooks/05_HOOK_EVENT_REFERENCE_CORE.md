# Hook Event Reference - Core
문서 ID: CC-HOOKS-EVENT-CORE
버전: v1.1.0

## 1. SessionStart
### 목적
세션 시작/재개 시 초기 컨텍스트를 주입한다.
### 주요 용도
- 개발 환경 안내
- 최근 변경점 요약
- CLAUDE_ENV_FILE 기반 환경변수 준비
### 특징
- command hook만 지원
- source: startup/resume/clear/compact

## 2. InstructionsLoaded
### 목적
CLAUDE.md 또는 .claude/rules/*.md가 컨텍스트에 로드될 때 감시한다.
### 주요 용도
- 감사 로그
- 어떤 규칙이 언제 로드됐는지 추적
### 특징
- 차단 불가
- 비동기 관측 이벤트

## 3. UserPromptSubmit
### 목적
사용자 프롬프트 처리 전에 검증 또는 보강한다.
### 주요 용도
- 금지 요청 차단
- 프롬프트 전처리
- 추가 컨텍스트 주입
### 제어
- decision=block 가능
- additionalContext 가능

## 4. PreToolUse
### 목적
도구 실행 직전 정책 게이트 역할을 수행한다.
### 대상 도구
Bash, Edit, Write, Read, Glob, Grep, Agent, WebFetch, WebSearch, AskUserQuestion, ExitPlanMode, MCP tools
### 제어
- permissionDecision: allow / deny / ask / defer
- updatedInput
- additionalContext

## 5. PermissionRequest
### 목적
permission dialog 직전에 개입하여 사용자 대신 허용/거부를 결정한다.
### 제어
- behavior: allow / deny
- updatedInput
- updatedPermissions
- message
- interrupt

## 6. PermissionDenied
### 목적
auto mode classifier가 도구를 거부한 경우 후속 처리한다.
### 제어
- retry: true 가능
### 비고
- 수동 거부에는 발생하지 않음

## 7. PostToolUse
### 목적
도구 성공 실행 후 검증과 후처리를 수행한다.
### 주요 용도
- lint/test 수행
- MCP output 보정
- 추가 컨텍스트 주입

## 8. PostToolUseFailure
### 목적
도구 실패 후 원인 설명, 로깅, 보정 문맥을 제공한다.
### 주요 용도
- 실패 원인 보강
- 재시도 전략 가이드
