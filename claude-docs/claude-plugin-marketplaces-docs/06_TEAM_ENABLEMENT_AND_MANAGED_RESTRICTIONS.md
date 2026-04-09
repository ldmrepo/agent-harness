# 06. 팀 적용과 Managed Restriction

문서 버전: v1.0.0

## 1. 팀 자동 노출
프로젝트에서 팀원에게 marketplace를 자동 인식시키려면 `.claude/settings.json`에 `extraKnownMarketplaces`를 넣을 수 있다.

```json
{
  "extraKnownMarketplaces": {
    "company-tools": {
      "source": {
        "source": "github",
        "repo": "your-org/claude-plugins"
      }
    }
  }
}
```

## 2. 기본 활성 plugin 지정
```json
{
  "enabledPlugins": {
    "code-formatter@company-tools": true,
    "deployment-tools@company-tools": true
  }
}
```

## 3. strictKnownMarketplaces
조직이 허용된 marketplace만 쓰게 하려면 managed settings에서 `strictKnownMarketplaces`를 사용할 수 있다.

### 모든 marketplace 추가 차단
```json
{
  "strictKnownMarketplaces": []
}
```

### 특정 marketplace만 허용
```json
{
  "strictKnownMarketplaces": [
    {
      "source": "github",
      "repo": "acme-corp/approved-plugins"
    }
  ]
}
```

## 4. hostPattern / pathPattern
### internal git host 허용
```json
{
  "strictKnownMarketplaces": [
    {
      "source": "hostPattern",
      "hostPattern": "^github\\.example\\.com$"
    }
  ]
}
```

### 특정 filesystem path 허용
```json
{
  "strictKnownMarketplaces": [
    {
      "source": "pathPattern",
      "pathPattern": "^/opt/approved/"
    }
  ]
}
```

## 5. managed-mcp와 유사하지만 다른 지점
Marketplace restriction은 **plugin catalog 접근 통제**이고, plugin 내부 기능 통제와는 다른 층위다.

## 6. 운영 권장안
- 조직 표준 marketplace는 `extraKnownMarketplaces`로 노출
- 허용되지 않은 marketplace는 `strictKnownMarketplaces`로 차단
- 사내 GitHub Enterprise / GitLab host 기준 regex allowlist 구성
- 개인 실험은 별도 개발 환경에서만 허용

## 7. 실무 판단 기준
### 완전 통제형 조직
- `strictKnownMarketplaces: []` 또는 허용 목록 최소화

### 유연 통제형 조직
- internal hostPattern 허용
- 외부 public marketplace는 차단

### 팀 자율형
- extraKnownMarketplaces만 제공하고 추가는 자유 허용
