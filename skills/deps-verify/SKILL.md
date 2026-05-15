---
name: Go Dependency Verification
description: Use when the user asks about Go dependencies, go.mod, go.sum, or module verification. Trigger on phrases "dependencies", "go mod", "verify deps", "tidy deps", "module check", "dependency audit". Runs go mod verify and/or go mod tidy.
argument-hint: "[verify|tidy|both]"
allowed-tools: Bash
---

Verify and/or tidy Go module dependencies.

1. Run the go-tool-installer agent to verify the environment.
2. Unless the user specified "verify", "tidy", or "both" as argument, ask:
   > "Which operation?
   > (a) verify — check module download checksums (read-only, safe in CI)
   > (b) tidy — add missing and remove unused dependencies (modifies go.mod/go.sum)
   > (c) both — run verify then tidy"
3. Wait for user selection.
4. Run the deps-verify script:
   ```
   bash "$(ls ~/.claude/plugins/cache/athapong-go-checker/go-checker/*/scripts/deps-verify.sh 2>/dev/null | head -1)" <verify|tidy|both>
   ```
5. Show the full output.
6. If `tidy` ran, tell the user: "go.mod and go.sum may have been modified. Review changes with `git diff go.mod go.sum` before committing."
7. Tell the user the report was saved to `./go-checker-reports/deps-verify-<timestamp>.txt`.
