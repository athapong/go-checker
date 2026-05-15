---
name: Go Security Audit
description: Use when the user asks for a full Go security audit or comprehensive security check. Trigger on phrases "security audit", "full security scan", "complete security check", "security audit all". Runs gosec + govulncheck + golangci-lint security rules sequentially.
argument-hint: "[package path]"
allowed-tools: Bash
---

Run a full security audit on a Go repository: gosec, govulncheck, and golangci-lint security rules.

1. Run the go-tool-installer agent to verify the environment.
2. Determine package scope: use argument if provided, otherwise `./...`.
3. Tell the user: "Running full security audit (3 tools). This may take a minute."

**Tool 1: gosec**
4. Run:
   ```
   bash $CLAUDE_PLUGIN_ROOT/scripts/security-scan.sh [package]
   ```
5. Show output. If output contains "Error" or no results section found, ask the user: "gosec encountered an issue. Continue with govulncheck? (yes/no)"
   - If no: stop and summarize what ran.
   - If yes: continue.

**Tool 2: govulncheck**
6. Run:
   ```
   bash $CLAUDE_PLUGIN_ROOT/scripts/vuln-scan.sh [package]
   ```
7. Show output. If output contains "Skipping vuln-scan" (Go < 1.21), note it and continue. If output contains "Error", ask the user: "govulncheck encountered an issue. Continue with lint security rules? (yes/no)"
   - If no: stop and summarize.
   - If yes: continue.

**Tool 3: golangci-lint (security rules)**
8. Run:
   ```
   bash $CLAUDE_PLUGIN_ROOT/scripts/lint.sh [package]
   ```
9. Show output.

**Summary**
10. Present a combined summary:
    - gosec findings: N HIGH, N MEDIUM, N LOW
    - govulncheck findings: N CVEs
    - lint security findings: N issues
    - Total: N issues found across 3 tools
11. Tell the user reports were saved to `./go-checker-reports/` with timestamps.
