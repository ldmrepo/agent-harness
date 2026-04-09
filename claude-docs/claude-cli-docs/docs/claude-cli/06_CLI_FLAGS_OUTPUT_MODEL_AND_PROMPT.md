# 모델, 출력, 시스템 프롬프트 플래그
문서 ID: CC-CLI-MODEL-OUTPUT-PROMPT
버전: v1.0.0

## 1. 모델 관련
### 1.1 `--model`
현재 세션의 모델 지정

### 1.2 `--effort`
추론 깊이 지정
- low
- medium
- high
- max(Opus 4.6 only)

### 1.3 `--fallback-model`
기본 모델 과부하 시 print mode에서 폴백 모델 사용

## 2. 출력 관련
### 2.1 `--output-format`
- text
- json
- stream-json

### 2.2 `--input-format`
- text
- stream-json

### 2.3 `--json-schema`
구조화된 JSON 출력 강제

### 2.4 `--max-turns`
agentic turn 수 제한

### 2.5 `--max-budget-usd`
비대화형 실행의 API 비용 상한

## 3. 시스템 프롬프트 관련
### 3.1 `--system-prompt`
기본 system prompt 전체 교체

### 3.2 `--system-prompt-file`
파일 내용으로 전체 교체

### 3.3 `--append-system-prompt`
기본 system prompt 뒤에 추가

### 3.4 `--append-system-prompt-file`
파일 내용을 기본 system prompt 뒤에 추가

## 4. 사용 원칙
- 일반적으로 append 계열 우선
- replace 계열은 완전 제어가 필요한 경우만 사용
