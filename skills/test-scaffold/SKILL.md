---
name: Go Test Scaffold
description: Use when the user wants to generate Go test stubs or scaffolding. Trigger on phrases "generate tests", "test stubs", "create tests", "gotests", "scaffold tests". Generates _test.go files using gotests.
argument-hint: "[file.go or package path]"
allowed-tools: Bash, Read
---

Generate Go test scaffolding using gotests.

1. Run the go-tool-installer agent to verify the environment.
2. Ask the user to choose scope (unless argument already provided):
   > "Run test scaffold on:
   > (a) Current file — specify filename
   > (b) Specific package — specify package path
   > (c) All packages — ./..."
3. Wait for the user's answer and confirm the target before proceeding.
4. Run the test scaffold script:
   ```
   bash $CLAUDE_PLUGIN_ROOT/scripts/test-scaffold.sh <target>
   ```
5. Show the output. List any new `_test.go` files created.
6. Tell the user: "Test files created with stubs for all exported functions. Fill in the test logic for each function."
