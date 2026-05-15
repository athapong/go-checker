---
name: Go Race Check
description: Use when the user asks about Go race conditions, data races, or concurrent code safety. Trigger on phrases "race conditions", "data race", "race detector", "concurrent", "go test race". Runs go test -race on the repository.
argument-hint: "[package path]"
allowed-tools: Bash
---

Run the Go race detector on a Go repository.

1. Run the go-tool-installer agent to verify the environment.
2. If the user provided a package path, use it. Otherwise use `./...`.
3. Run the race check script:
   ```
   bash "$(ls ~/.claude/plugins/cache/athapong-go-checker/go-checker/*/scripts/race-check.sh 2>/dev/null | head -1)" [package]
   ```
4. Show the full output to the user.
5. If race conditions are found (output contains "DATA RACE"), highlight the goroutines involved and the conflicting access locations.
6. If no tests exist (output: "no test files"), tell the user: "No test files found. Race detection requires tests. Add tests to detect races."
7. Tell the user the report was saved to `./go-checker-reports/race-check-<timestamp>.txt`.
