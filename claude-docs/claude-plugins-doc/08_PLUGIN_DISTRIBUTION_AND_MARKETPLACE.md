# 08. Plugin 배포와 Marketplace

문서 버전: v1.0.0

## 1. 배포 목적
플러그인을 만든 뒤 팀 또는 커뮤니티와 공유하려면 marketplace 배포 모델을 고려해야 한다.

## 2. 배포 전 준비
- README.md 작성
- plugin version 정리
- CHANGELOG 관리
- 설치/사용 예시 제공
- 테스트 완료

## 3. version 관리
공식 문서 기준으로 semantic versioning 사용이 권장된다.
- MAJOR: 호환성 깨짐
- MINOR: 기능 추가
- PATCH: 수정

## 4. marketplace와의 관계
Plugin은 실제 기능 패키지이고, marketplace는 플러그인 카탈로그와 배포 경로를 제공하는 유통 계층이다.

## 5. 설치 예시
```bash
claude plugin install formatter@my-marketplace
```

## 6. 공식 마켓 제출
공식 문서에는 Anthropic 공식 marketplace 제출 경로가 안내되어 있다.
- Claude.ai 제출 폼
- Console 제출 폼

## 7. 조직 내 배포 패턴
### 7.1 팀 내부 전용 marketplace
사내 Git 저장소 기반으로 운영

### 7.2 공식 marketplace 공개
외부 사용자 대상 공개 배포

### 7.3 managed settings 결합
필수 plugin은 관리형으로, 선택 plugin은 marketplace로

## 8. 배포 시 주의사항
- 경로 의존성 최소화
- 외부 실행 파일/서버 의존성 명시
- LSP/MCP prerequisite 문서화
- 민감값은 userConfig 또는 환경변수로 분리
