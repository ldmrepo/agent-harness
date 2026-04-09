# 07. Marketplace CLI와 운영 절차

문서 버전: v1.0.0

## 1. 핵심 CLI
### add
```bash
claude plugin marketplace add <source> [options]
```

### list
```bash
claude plugin marketplace list
claude plugin marketplace list --json
```

### remove
```bash
claude plugin marketplace remove <name>
```

### update
```bash
claude plugin marketplace update [name]
```

## 2. add 예시
### GitHub shorthand
```bash
claude plugin marketplace add acme-corp/claude-plugins
```

### branch/tag pin
```bash
claude plugin marketplace add acme-corp/claude-plugins@v2.0
```

### git URL
```bash
claude plugin marketplace add https://gitlab.example.com/team/plugins.git
```

### local directory
```bash
claude plugin marketplace add ./my-marketplace
```

### project scope
```bash
claude plugin marketplace add acme-corp/claude-plugins --scope project
```

### sparse checkout
```bash
claude plugin marketplace add acme-corp/monorepo --sparse .claude-plugin plugins
```

## 3. scope 선택
- `user`: 개인 전체 프로젝트
- `project`: 프로젝트 공유
- `local`: 현재 프로젝트에서 나만 사용

## 4. remove 주의
marketplace를 remove하면 그 marketplace에서 설치한 plugin도 함께 uninstall될 수 있다.  
단순 refresh 목적이면 remove 대신 update를 쓴다.

## 5. update 전략
- 전체 일괄 업데이트
- 특정 marketplace만 업데이트
- seed-managed marketplace는 read-only라 update 실패 가능

## 6. 운영 표준 절차
1. validate
2. local add로 테스트
3. install 확인
4. team/project scope 반영
5. release tag/ref 또는 SHA pinning
6. 운영 중 update cadence 정의

## 7. 대화형 명령 대응
interactive 세션에서는 `/plugin marketplace ...`로 같은 동작을 수행할 수 있다.
