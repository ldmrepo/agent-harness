# 09. Standalone 설정을 Plugin으로 마이그레이션

문서 버전: v1.0.0

## 1. 마이그레이션 대상
- `.claude/commands/`
- `.claude/agents/`
- `.claude/skills/`
- settings에 정의한 hooks

## 2. 기본 절차
### 2.1 plugin 골격 생성
```bash
mkdir -p my-plugin/.claude-plugin
```

`my-plugin/.claude-plugin/plugin.json`
```json
{
  "name": "my-plugin",
  "description": "Migrated from standalone configuration",
  "version": "1.0.0"
}
```

### 2.2 기존 파일 복사
```bash
cp -r .claude/commands my-plugin/
cp -r .claude/agents my-plugin/
cp -r .claude/skills my-plugin/
```

### 2.3 hooks 이전
```bash
mkdir my-plugin/hooks
```

`my-plugin/hooks/hooks.json`로 `settings.json`의 hooks 객체를 옮긴다.

## 3. 변경되는 점
| Standalone | Plugin |
|---|---|
| 한 프로젝트에 종속 | 여러 프로젝트에 재사용 가능 |
| 수동 복사 중심 | 설치/업데이트 가능 |
| 짧은 command 이름 | plugin namespace 사용 |
| settings에 hooks 분산 | plugin 내부 `hooks/hooks.json`로 응집 |

## 4. 테스트
```bash
claude --plugin-dir ./my-plugin
```

## 5. 마이그레이션 후 권장 작업
- 중복되는 기존 `.claude/` 설정 제거
- README 추가
- 버전 부여
- 배포 방식 결정
