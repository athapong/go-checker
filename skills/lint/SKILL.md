---
name: Go Lint
description: Use when the user mentions Go code quality, linting, or static analysis. Trigger on phrases "lint", "code quality", "golangci", "check code style", "static analysis", "run linter". Runs golangci-lint on the Go repository.
argument-hint: "[package path]"
allowed-tools: Bash
---

Run golangci-lint to check Go code quality.

1. Run the go-tool-installer agent to verify the environment.
2. If the user provided a package path as argument, use it. Otherwise use `./...`.
3. Run the lint script:
   ```
   bash "$(ls ~/.claude/plugins/cache/athapong-go-checker/go-checker/*/scripts/lint.sh 2>/dev/null | head -1)" [package]
   ```
4. Show the full output to the user.
5. Summarize: total issues found, which linters triggered, and which files have the most issues.
6. Tell the user the report was saved to `./go-checker-reports/lint-<timestamp>.txt`.
