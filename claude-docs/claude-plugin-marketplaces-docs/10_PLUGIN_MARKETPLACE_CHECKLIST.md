# 10. Plugin Marketplace 운영 체크리스트

문서 버전: v1.0.0

## 1. 설계 체크
- [ ] marketplace name이 명확하고 충돌/오해 소지가 없다
- [ ] owner 정보가 정리되어 있다
- [ ] plugin naming 규칙이 kebab-case로 통일되어 있다
- [ ] plugin source 전략(relative/github/url/git-subdir/npm)이 목적에 맞다
- [ ] stable/latest 같은 release channel 필요 여부가 결정되었다

## 2. 구현 체크
- [ ] `.claude-plugin/marketplace.json`이 존재한다
- [ ] plugin entry마다 `name`, `source`가 있다
- [ ] 필요 시 `metadata.pluginRoot`를 사용한다
- [ ] `strict` 모드 사용 이유가 명확하다
- [ ] plugin 내부 외부경로 참조 문제가 없다

## 3. 검증 체크
- [ ] `claude plugin validate .` 통과
- [ ] local marketplace add 테스트 완료
- [ ] plugin install 및 실행 테스트 완료
- [ ] update / remove 시나리오 점검 완료

## 4. 배포 체크
- [ ] GitHub/GitLab/internal git 호스팅 경로 확정
- [ ] private repo 인증 전략 문서화
- [ ] 팀/조직 적용 시 `extraKnownMarketplaces` 설정 준비
- [ ] 제한 정책이 필요하면 `strictKnownMarketplaces` 설계 완료

## 5. 운영 체크
- [ ] Git timeout 값이 환경에 맞게 조정되었다
- [ ] offline/airgapped 환경이면 seed 전략이 준비되었다
- [ ] background auto-update token 공급 방식이 정해졌다
- [ ] 문제 발생 시 fallback / rollback 절차가 있다

## 6. 권장 운영안
- 소규모: GitHub + project scope
- 중간 규모 팀: internal git + extraKnownMarketplaces
- 엔터프라이즈/폐쇄망: managed restriction + seed directory + pinned ref/SHA
