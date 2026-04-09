# 09. 제한사항과 트러블슈팅

## 1. 현재 알려진 제한사항

### 1.1 실험 기능
기능 자체가 실험 단계이며 기본 비활성화 상태이다.

### 1.2 in-process teammate 세션 재개 문제
`/resume`, `/rewind`가 in-process teammate를 복원하지 못할 수 있다.

### 1.3 태스크 상태 지연
완료했는데도 task가 completed로 반영되지 않아 후속 작업이 막힐 수 있다.

### 1.4 종료 지연
팀원이 현재 요청 또는 tool call을 마친 뒤 종료하므로 shutdown이 느릴 수 있다.

### 1.5 한 세션당 한 팀
리드는 동시에 하나의 팀만 관리할 수 있다.

### 1.6 nested teams 불가
팀원은 또 다른 팀을 생성할 수 없다.

### 1.7 spawn 시 개별 permission mode 직접 설정 불가
팀원은 생성 시점에 리드의 permission context를 따른다.

## 2. 자주 발생하는 문제

### 2.1 팀원이 안 보임
점검:
- 기능 활성화 여부
- 팀 생성 프롬프트가 충분히 병렬 가치가 있는지
- tmux / iTerm2 준비 여부
- in-process 모드에서 Shift+Down으로 순환 가능한지

### 2.2 권한 프롬프트가 너무 많음
해결:
- common operations를 사전 허용
- 위험이 낮은 작업을 미리 permission settings에 반영

### 2.3 에러 후 팀원이 멈춤
해결:
- 해당 팀원에게 직접 추가 지시
- 필요 시 replacement teammate 생성

### 2.4 리드가 너무 빨리 종료하려고 함
해결:
```text
Wait for teammates to finish before concluding.
```

### 2.5 orphaned tmux sessions
```bash
tmux ls
tmux kill-session -t <session-name>
```

## 3. 운영적 주의사항

- cleanup은 반드시 리드가 실행
- stuck task는 실제 완료 여부를 확인 후 수동 보정 고려
- 팀원 재생성 전략을 준비
