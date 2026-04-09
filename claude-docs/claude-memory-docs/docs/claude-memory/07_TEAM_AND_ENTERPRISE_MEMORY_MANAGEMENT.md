# 팀/엔터프라이즈용 memory 운영
문서 ID: CC-MEMORY-TEAM
버전: v1.0.0

## 1. 조직 전체 CLAUDE.md
조직은 managed policy 위치에 중앙 CLAUDE.md를 배포할 수 있다.
이 파일은 개별 사용자가 제외할 수 없다.

## 2. managed settings vs managed CLAUDE.md
### managed settings에 적합한 것
- permissions.deny
- sandbox.enabled
- env
- forceLoginMethod
- forceLoginOrgUUID

### managed CLAUDE.md에 적합한 것
- 코드 스타일 가이드
- 품질 기준
- 보안/컴플라이언스 주의사항
- Claude 행동 지침

## 3. monorepo 운영
다른 팀의 CLAUDE.md가 섞이면 `claudeMdExcludes`로 제외한다.

예:
```json
{
  "claudeMdExcludes": [
    "**/monorepo/CLAUDE.md",
    "/home/user/monorepo/other-team/.claude/rules/**"
  ]
}
```

## 4. rule 분리 전략
- root CLAUDE.md: 공통 규칙
- package별 rules: 도메인/언어/디렉토리 규칙
- user-level rules: 개인 선호도
- CLAUDE.local.md: 개인 프로젝트 전용 로컬 정보
