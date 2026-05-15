---
name: Go Vulnerability Scan
description: Use when the user asks about Go dependency vulnerabilities, CVEs, or govulncheck. Trigger on phrases "vulnerabilities", "CVE", "govulncheck", "dependency vulnerabilities", "known vulnerabilities". Requires Go 1.21+.
argument-hint: "[package path]"
allowed-tools: Bash
---

Run govulncheck to detect known CVEs in Go dependencies.

1. Run the go-tool-installer agent to verify the environment (checks Go version).
2. If agent reports Go < 1.21, tell the user: "govulncheck requires Go 1.21+. Please upgrade Go to use this skill." Stop.
3. If the user provided a package path, use it. Otherwise use `./...`.
4. Run the vuln scan script:
   ```
   bash $CLAUDE_PLUGIN_ROOT/scripts/vuln-scan.sh [package]
   ```
5. Show the full output to the user.
6. Summarize: number of vulnerabilities found, affected modules, and CVE IDs.
7. Tell the user the report was saved to `./go-checker-reports/vuln-scan-<timestamp>.txt`.
