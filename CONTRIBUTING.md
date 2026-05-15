# Contributing to go-checker

## Overview

go-checker is a Claude Code plugin. Each Go tool maps to:
- A **skill** (`skills/<name>/SKILL.md`) — instructs Claude what to do
- A **script** (`scripts/<name>.sh`) — runs the actual tool

Shared bash functions live in `scripts/common.sh`.

---

## Plugin Structure

```
go-checker/
├── .claude-plugin/
│   ├── plugin.json          # Plugin manifest
│   └── marketplace.json     # Marketplace registration
├── agents/
│   └── go-tool-installer.md # Pre-flight: checks Go version + installs tools
├── scripts/
│   ├── common.sh            # Shared functions (source this in every script)
│   └── <tool>.sh            # One script per tool
├── skills/
│   └── <tool>/
│       └── SKILL.md         # Claude instructions for each tool
├── CONTRIBUTING.md          # This file
└── README.md
```

---

## Adding a New Skill

### 1. Create the script

`scripts/<tool-name>.sh`:

```bash
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PACKAGE="${1:-./...}"

check_go_version
check_install_tool "<binary>" "<go-import-path>"

setup_reports_dir

echo "=== <tool-name> ==="
echo "Package: $PACKAGE"
echo ""

output=$(<binary> "$PACKAGE" 2>&1)
echo "$output"
save_report "<tool-name>" "$output"
```

Rules:
- Always source `common.sh` first
- Call `check_go_version` before anything else
- Call `check_install_tool "<binary>" "<import-path>"` for each required tool
- Call `setup_reports_dir` before writing reports
- Call `save_report "<tool-name>" "$output"` to save output
- Always exit 0 (user-facing plugin, not CI gate)
- Use `SCRIPT_DIR` pattern for sourcing — never hardcode paths

Make it executable: `chmod +x scripts/<tool-name>.sh`

### 2. Add tool to go-tool-installer agent

Edit `agents/go-tool-installer.md` — add a row to the tool table:

```markdown
| <binary> | `go install <import-path>@latest` |
```

### 3. Create the skill

`skills/<tool-name>/SKILL.md`:

```markdown
---
name: Go <Tool Name>
description: Use when the user asks about <topic>. Trigger on phrases "<phrase1>", "<phrase2>", "<phrase3>". <One sentence on what the tool does>.
argument-hint: "[package path]"
allowed-tools: Bash
---

<Imperative instructions for Claude — not for the user.>

1. Run the go-tool-installer agent to verify the environment.
2. Determine package scope: use argument if provided, otherwise `./...`.
3. Run the script:
   ```
   bash $CLAUDE_PLUGIN_ROOT/scripts/<tool-name>.sh [package]
   ```
4. Show the full output to the user.
5. Summarize findings.
6. Tell the user the report was saved to `./go-checker-reports/<tool-name>-<timestamp>.txt`.
```

Skill writing rules:
- `description` field drives both auto-triggering and slash command registration
- Use third-person present tense in `description`
- Write the body imperatively (step 1, step 2...) — instructions FOR Claude, not TO the user
- List concrete trigger phrases — more phrases = better auto-detection
- `allowed-tools: Bash` is sufficient for most tools; add `Read` if the skill reads files
- Reference `$CLAUDE_PLUGIN_ROOT/scripts/<name>.sh` — never hardcode absolute paths

### 4. Update README.md

Add a row to the Skills table:

```markdown
| `/go-checker:<tool-name>` | "<phrase1>", "<phrase2>" | <tool binary> |
```

### 5. Commit

```bash
git add scripts/<tool-name>.sh skills/<tool-name>/SKILL.md agents/go-tool-installer.md README.md
git commit -m "feat: add <tool-name> skill and script"
```

---

## Modifying an Existing Skill

- **Script logic changes** → edit `scripts/<tool>.sh`, test manually against a Go repo
- **Trigger phrase changes** → edit `description` in `skills/<tool>/SKILL.md`
- **Behavior changes** → edit body of `skills/<tool>/SKILL.md`
- **New tool dependency** → add `check_install_tool` call in script AND add row to `agents/go-tool-installer.md`

---

## common.sh Reference

All scripts source `scripts/common.sh`. Available functions:

| Function | Signature | Description |
|----------|-----------|-------------|
| `timestamp` | `timestamp` | Returns `YYYYMMDD-HHMMSS` |
| `setup_reports_dir` | `setup_reports_dir` | Creates `./go-checker-reports/` |
| `save_report` | `save_report <tool> <content>` | Writes `./go-checker-reports/<tool>-<ts>.txt` |
| `check_go_version` | `check_go_version` | Exits if Go not found; exports `GOVULNCHECK_AVAILABLE` |
| `check_install_tool` | `check_install_tool <binary> <import-path>` | Installs tool if missing |

`GOVULNCHECK_AVAILABLE` is exported by `check_go_version`:
- `true` — Go >= 1.21, govulncheck can run
- `false` — Go < 1.21, skip govulncheck

---

## Testing

### Test a script manually

```bash
# Create a minimal Go repo
mkdir -p /tmp/test-go && cd /tmp/test-go
go mod init example.com/test
echo 'package main; import "fmt"; func main() { fmt.Println("hi") }' > main.go

# Run your script
bash ~/Development/golang/go-checker/scripts/<tool-name>.sh ./...

# Check report created
ls ./go-checker-reports/
```

### Test common.sh functions

```bash
source ~/Development/golang/go-checker/scripts/common.sh
timestamp        # should print YYYYMMDD-HHMMSS
```

### Test the plugin in Claude Code

```bash
claude --plugin-dir ~/Development/golang/go-checker
```

Then trigger the skill by typing its trigger phrase or running `/go-checker:<tool-name>`.

---

## Installation

### Local development

```bash
claude --plugin-dir ~/Development/golang/go-checker
```

### Via local marketplace

```bash
/plugin marketplace add ~/Development/golang/go-checker
/plugin install go-checker@go-checker-marketplace
```

### Via Git (after pushing to remote)

```bash
/plugin marketplace add <github-user>/go-checker
/plugin install go-checker@<github-user>-go-checker
```

---

## Conventions

| Item | Convention |
|------|-----------|
| Script names | `kebab-case.sh` |
| Skill directories | `kebab-case/` |
| Commit messages | `feat: add <tool> skill and script` |
| Report names | `<tool-name>` (matches script name without `.sh`) |
| Exit codes | Always 0 (CI mode not supported) |
| Path references | Always use `$CLAUDE_PLUGIN_ROOT` — never hardcode |
| Go version gate | Check `$GOVULNCHECK_AVAILABLE` for tools requiring Go 1.21+ |
