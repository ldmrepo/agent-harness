# Skill 설계 패턴과 레시피

## 1. 설명형 skill

목적:
- 코드 설명
- 구조 설명
- onboarding

패턴:
- analogy
- ASCII diagram
- step-by-step
- gotcha

## 2. 배포형 skill

권장 frontmatter:
```yaml
disable-model-invocation: true
context: fork
```

포함 권장 내용:
- pre-check
- build
- deploy
- verify
- rollback hint

## 3. 조사형 skill

권장 frontmatter:
```yaml
context: fork
agent: Explore
```

포함 권장 내용:
- 검색 범위
- 파일 조사 기준
- 결과 포맷
- file reference 기준

## 4. GitHub/PR 요약형 skill

권장 요소:
- gh CLI 기반 context injection
- changed files
- comments
- diff
- review checklist

## 5. 리드온리 점검형 skill

권장:
```yaml
allowed-tools: Read Grep Glob
```

## 6. 생성형 skill

예:
- 문서 템플릿 생성
- 코드 scaffold 생성
- migration plan 생성

패턴:
- supporting template file
- argument-hint
- examples.md 포함

## 7. 시각화 skill

예:
- interactive HTML output
- built-in libraries 우선
- output path 명시
- open-in-browser 단계 명시
