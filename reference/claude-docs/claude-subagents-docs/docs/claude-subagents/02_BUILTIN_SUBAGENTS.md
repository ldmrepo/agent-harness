# 02. Built-in Subagents

## 1. 개요

Claude Code는 기본 제공 subagent를 포함한다. 공식 문서에서 대표적으로 설명하는 built-in subagent는 다음과 같다.

- Explore
- Plan
- general-purpose
- 그 외 보조 agent(statusline-setup, Claude Code Guide)

## 2. Explore

### 목적
빠르고 읽기 전용으로 코드베이스를 탐색하는 agent.

### 특성
- 모델: Haiku
- 도구: Read-only 계열 중심
- Write/Edit 금지
- 파일 발견, 검색, 구조 파악에 최적화

### 적합한 상황
- “이 코드베이스 구조를 조사해”
- “인증 관련 파일을 찾아줘”
- “어디서 이 함수가 호출되는지 분석해”

## 3. Plan

### 목적
plan mode에서 계획 수립 전 필요한 코드 조사 수행.

### 특성
- 모델: 메인 대화 상속
- 도구: Read-only
- 역할: 계획 수립을 위한 근거 수집

### 적합한 상황
- 리팩터링 계획 수립
- 구현 전 영향 범위 분석
- 설계 변경 전에 코드 경로 조사

## 4. General-purpose

### 목적
탐색과 수정이 함께 필요한 복합 작업 수행.

### 특성
- 모델: 메인 대화 상속
- 도구: 전체 사용 가능
- 조사 → 수정 → 검증의 다단계 작업에 적합

### 적합한 상황
- 버그 수정
- 다단계 코드 변경
- 수정 후 테스트까지 수행하는 작업

## 5. 기타 built-in agent

### statusline-setup
- `/statusline` 설정 시 사용
- UI/설정 보조 목적

### Claude Code Guide
- Claude Code 기능 질의응답 보조
- 문서 안내형 역할

## 6. 실무 해석

가장 중요한 구분은 다음이다.

- Explore = 가볍고 안전한 탐색 전용
- Plan = 계획 모드용 조사 전용
- general-purpose = 실제 작업 수행형

custom subagent를 만들 때도 이 세 가지 패턴을 기준축으로 삼으면 설계가 쉬워진다.
