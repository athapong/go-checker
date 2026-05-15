# go-checker

Claude Code plugin for Go repository quality, security, profiling, and documentation.

## Prerequisites

- Go 1.18+ (Go 1.21+ for vuln-scan)
- Internet access for initial tool installation (auto-installed on first use)

## Skills

| Slash Command | Trigger Phrases | Tool |
|--------------|-----------------|------|
| `/go-checker:lint` | "lint", "code quality", "golangci" | golangci-lint |
| `/go-checker:security-scan` | "security", "gosec" | gosec |
| `/go-checker:vuln-scan` | "vulnerabilities", "CVE" | govulncheck |
| `/go-checker:security-audit` | "security audit", "full security" | gosec + govulncheck + golangci-lint |
| `/go-checker:test-scaffold` | "generate tests", "test stubs" | gotests |
| `/go-checker:race-check` | "race conditions", "data race" | go test -race |
| `/go-checker:profile-cpu` | "profile", "cpu performance" | go test -bench + pprof |
| `/go-checker:profile-memory` | "memory profile", "heap" | go test -bench + pprof |
| `/go-checker:deps-verify` | "dependencies", "go mod" | go mod verify/tidy |
| `/go-checker:docs-generate` | "documentation", "API docs", "godoc", "swagger" | godoc or swag |
| `/go-checker:struct-layout` | "struct layout", "memory layout", "struct padding", "optimize struct" | structlayout + structlayout-optimize |

## Installation

```bash
/plugin marketplace add athapong/go-checker
/plugin install go-checker@athapong-go-checker
```

Or clone and test locally:

```bash
git clone https://github.com/athapong/go-checker
claude --plugin-dir ./go-checker
```

## Reports

Tool output is saved to `./go-checker-reports/<tool>-YYYYMMDD-HHMMSS.txt` in the checked repository.
