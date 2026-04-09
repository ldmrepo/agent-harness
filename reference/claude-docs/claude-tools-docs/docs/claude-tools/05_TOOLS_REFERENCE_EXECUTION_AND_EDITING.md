# 실행 및 수정 도구 상세
문서 ID: CC-TOOLS-EXEC-EDIT
버전: v1.0.0

## 1. Bash
### 목적
셸 명령을 실행한다.
### 대표 용도
- npm test
- git status
- build 실행
- 스크립트 호출
### 권한
필요

## 2. PowerShell
### 목적
Windows에서 PowerShell 명령을 네이티브로 실행한다.
### 권한
필요
### 비고
preview 기능

## 3. NotebookEdit
### 목적
Jupyter notebook 셀을 수정한다.
### 권한
필요

## 4. Edit vs Write 선택 기준
### Edit가 적합한 경우
- 기존 파일의 특정 블록 수정
- 최소 diff 유지

### Write가 적합한 경우
- 새 파일 생성
- 파일 전체 재구성
- 기존 내용 전면 교체

## 5. WebFetch
### 목적
특정 URL의 콘텐츠를 가져온다.
### 권한
필요

## 6. WebSearch
### 목적
웹 검색을 수행한다.
### 권한
필요
