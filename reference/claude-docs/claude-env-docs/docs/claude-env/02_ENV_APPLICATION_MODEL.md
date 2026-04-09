# Environment Variables 적용 모델
문서 ID: CC-ENV-APPLY
버전: v1.0.0

## 1. 적용 방식
Claude Code는 실행 시 프로세스 환경과 settings.json의 `env`를 읽어 동작을 결정한다.

## 2. 적용 위치
### 2.1 셸 환경
예:
```bash
export ANTHROPIC_API_KEY=...
export CLAUDE_CODE_EFFORT_LEVEL=high
claude
```

### 2.2 settings.json
예:
```json
{
  "env": {
    "CLAUDE_CODE_EFFORT_LEVEL": "high"
  }
}
```

## 3. 적용 시점
- 대부분 실행 시작 시 적용
- 일부는 세션 중 동작에 지속 영향
- 일부는 특정 모드(-p, auto mode, provider mode)에서만 의미가 있음

## 4. 우선순위 해석
일반적으로 환경변수는 강한 런타임 제어 수단이다.
다만 변수마다 settings와의 precedence가 다를 수 있으므로 개별 설명을 확인한다.

## 5. CLI flags와의 관계
- `--bare` → `CLAUDE_CODE_SIMPLE`
- `--debug-file` → `CLAUDE_CODE_DEBUG_LOGS_DIR`를 대체하면서 debug도 활성화
- `--effort` ↔ `CLAUDE_CODE_EFFORT_LEVEL`
- provider 관련 플래그/설정 ↔ `CLAUDE_CODE_USE_*`
- thinking 관련 기능 ↔ `MAX_THINKING_TOKENS`, `CLAUDE_CODE_DISABLE_*`

## 6. 운영 원칙
- 실험성 변수는 local/user scope에 두고 project scope에는 최소화
- 조직 공통 정책은 managed settings 또는 표준 env template로 관리
- 민감 자격증명은 프로젝트 파일에 커밋하지 않음
