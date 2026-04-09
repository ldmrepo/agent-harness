# 실전 레시피 및 치트시트
문서 ID: CC-CLI-RECIPES
버전: v1.0.0

## 1. 새 작업 시작
```bash
claude -n auth-refactor
```

## 2. 최근 세션 이어서 계속
```bash
claude -c
```

## 3. 특정 세션 재개
```bash
claude -r auth-refactor
```

## 4. 계획 모드로 시작
```bash
claude --permission-mode plan
```

## 5. 비대화형 JSON 결과
```bash
claude -p "analyze this repository" --output-format json
```

## 6. 시스템 프롬프트 추가 규칙
```bash
claude --append-system-prompt-file ./style-rules.txt
```

## 7. 병렬 worktree 세션
```bash
claude -w feature-auth -n feature-auth
```

## 8. 최소 헤드리스 호출
```bash
claude --bare -p "summarize the diff"
```

## 9. 특정 도구만 허용
```bash
claude --tools "Bash,Edit,Read"
```

## 10. 프록시/게이트웨이 환경 예시
```bash
ANTHROPIC_BASE_URL=https://my-gateway.example.com claude
```
