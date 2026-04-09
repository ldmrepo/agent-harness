# 05. MCP 스코프와 우선순위

## 1. 스코프 종류
- local: 현재 프로젝트에서 나만 사용
- project: `.mcp.json`으로 팀과 공유
- user: 모든 프로젝트에서 개인적으로 사용

## 2. 저장 위치 개념
- user/local: `~/.claude.json`
- project: 프로젝트 루트의 `.mcp.json`
- managed: 시스템 관리 경로의 `managed-mcp.json`

## 3. 선택 기준
- local: 실험용, 민감한 자격 증명, 개인 전용
- project: 팀 공용 도구, 저장소 표준 도구
- user: 여러 프로젝트에서 반복 사용하는 개인 도구

## 4. 우선순위
동일한 이름의 MCP 서버가 여러 스코프에 있으면 일반적으로 다음 순서로 적용된다.
- local
- project
- user

## 5. 협업 관점
프로젝트 공통 도구는 `.mcp.json`으로 버전 관리하고, 개인 자격 증명이나 실험 서버는 local/user로 분리하는 것이 가장 안전하다.
