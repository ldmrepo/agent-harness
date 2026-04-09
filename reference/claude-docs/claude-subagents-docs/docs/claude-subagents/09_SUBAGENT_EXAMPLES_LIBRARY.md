# 09. 예제 라이브러리

## 1. Code reviewer

```markdown
---
name: code-reviewer
description: Expert code review specialist. Proactively reviews code for quality, security, and maintainability. Use immediately after writing or modifying code.
tools: Read, Grep, Glob, Bash
model: inherit
---

You are a senior code reviewer...
```

### 특징
- read-only 중심
- 최근 변경사항 검토
- 품질/보안/유지보수성 분류

## 2. Debugger

```markdown
---
name: debugger
description: Debugging specialist for errors, test failures, and unexpected behavior. Use proactively when encountering any issues.
tools: Read, Edit, Bash, Grep, Glob
---

You are an expert debugger...
```

### 특징
- 원인 분석 + 수정 + 검증
- Edit 허용

## 3. Data scientist

```markdown
---
name: data-scientist
description: Data analysis expert for SQL queries, BigQuery operations, and data insights.
tools: Bash, Read, Write
model: sonnet
---

You are a data scientist...
```

### 특징
- 도메인 특화형
- SQL/분석 중심

## 4. DB reader with hook

```markdown
---
name: db-reader
description: Execute read-only database queries. Use when analyzing data or generating reports.
tools: Bash
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-readonly-query.sh"
---
```

### 특징
- Bash 허용
- hook으로 SQL write 차단

## 5. Minimal research agent

```markdown
---
name: repo-researcher
description: Read-only researcher for large codebases. Use proactively for file discovery, architecture tracing, and dependency mapping.
tools: Read, Grep, Glob
model: haiku
permissionMode: plan
---

You are a repository research specialist.
Return only:
- key findings
- file paths
- recommended next checks
```

## 6. Memory-enabled reviewer

```markdown
---
name: persistent-reviewer
description: Reviews code and accumulates project review patterns over time.
tools: Read, Grep, Glob, Bash
memory: project
---

You are a reviewer that maintains institutional knowledge.
Update memory with recurring issues, code patterns, and architectural conventions.
```
