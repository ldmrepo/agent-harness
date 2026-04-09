# 07. 실행 모드와 컨텍스트 관리

## 1. Foreground vs Background

### foreground
- 메인 대화를 block
- permission prompt, clarifying question 전달 가능
- 상호작용형 작업에 적합

### background
- 병렬 실행
- 계속 다른 작업 가능
- 사전 승인된 permission만 사용
- 중간 질문이 필요한 경우 실패할 수 있음

## 2. Background 제어

- Claude에게 “run this in the background” 요청
- Ctrl+B로 background 전환
- `background: true`로 기본 background 실행 설정 가능

## 3. Context isolation

subagent는 별도 context window를 가진다.

이로 인해:
- 로그/탐색 결과가 main context를 덜 오염시킴
- 긴 조사 작업을 외부로 격리 가능
- 최종 요약만 메인으로 돌아옴

## 4. Resume subagents

실행된 subagent는 agent ID를 갖고, 나중에 재개할 수 있다.

핵심 특징:
- 이전 tool call/history 유지
- 같은 작업을 fresh start하지 않고 이어감
- transcript가 별도 저장됨

## 5. Transcript persistence

subagent transcript는 메인 대화와 별도 파일에 저장된다.

이점:
- main conversation compact와 분리
- 세션 재개 시 subagent 문맥 복원 가능
- 일정 기간 후 cleanup

## 6. Auto-compaction

subagent도 자동 compact를 지원한다.  
기본 트리거는 약 95%이며 `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`로 조절 가능하다.

## 7. Isolation: worktree

`isolation: worktree`를 사용하면 subagent는 임시 git worktree에서 실행된다.

장점:
- 원본 작업 디렉토리와 분리
- 충돌 감소
- 병렬 작업에 유리

주의:
- 변경이 없으면 자동 cleanup
- 변경이 있으면 유지/정리 흐름을 고려해야 함

## 8. 선택 가이드

- 자주 질문/수정 반복 필요 → foreground
- 긴 테스트/조사/대량 처리 → background
- 충돌 없는 병렬 개발 필요 → worktree isolation
