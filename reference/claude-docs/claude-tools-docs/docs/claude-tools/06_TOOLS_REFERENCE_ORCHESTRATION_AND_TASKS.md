# 오케스트레이션, Task, Worktree 도구
문서 ID: CC-TOOLS-ORCH
버전: v1.0.0

## 1. AskUserQuestion
### 목적
다중 선택 질문으로 요구사항을 수집한다.
### 특징
- 무권한
- 애매한 요구사항 정리용

## 2. EnterPlanMode / ExitPlanMode
### 목적
실행 전에 계획을 세우고 승인받는 흐름을 제어한다.
### 특징
- EnterPlanMode: 무권한
- ExitPlanMode: 권한 필요

## 3. EnterWorktree / ExitWorktree
### 목적
격리된 git worktree로 진입하고 원래 디렉토리로 복귀한다.
### 특징
- 병렬 세션/충돌 없는 수정에 적합

## 4. Task 계열
- TaskCreate
- TaskGet
- TaskList
- TaskUpdate
- TaskStop
- TaskOutput (deprecated)

### 역할
세션 task list 및 background task 관리

## 5. Cron 계열
- CronCreate
- CronList
- CronDelete

### 역할
현재 세션 안의 one-shot / recurring prompt scheduling

## 6. TodoWrite
### 역할
비대화형 모드와 Agent SDK에서 checklist를 관리한다.

## 7. TeamCreate / TeamDelete / SendMessage
### 역할
agent team 생성, 정리, teammate 메시징
### 비고
실험 기능이며 환경변수 활성화 필요
