---
name: Go Security Scan
description: Use when the user asks about Go security issues, security scanning, or gosec. Trigger on phrases "security", "gosec", "security issues", "security check", "OWASP". Runs gosec to detect security vulnerabilities in Go code.
argument-hint: "[package path]"
allowed-tools: Bash
---

Run gosec to detect security issues in Go code.

1. Run the go-tool-installer agent to verify the environment.
2. If the user provided a package path as argument, use it. Otherwise use `./...`.
3. Run the security scan script:
   ```
   bash $CLAUDE_PLUGIN_ROOT/scripts/security-scan.sh [package]
   ```
4. Show the full output to the user.
5. Summarize: severity breakdown (HIGH/MEDIUM/LOW), CWE categories found, and affected files.
6. Tell the user the report was saved to `./go-checker-reports/security-scan-<timestamp>.txt`.
