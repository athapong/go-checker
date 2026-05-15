---
name: Go Documentation Generator
description: Use when the user wants to generate Go documentation, API docs, or browse package docs. Trigger on phrases "documentation", "API docs", "godoc", "swagger", "openapi", "generate docs". Supports godoc (browser UI) and swag (OpenAPI/Swagger YAML).
argument-hint: "[godoc|swag]"
allowed-tools: Bash
---

Generate Go documentation using godoc or swag.

1. Run the go-tool-installer agent to verify the environment.
2. Unless the user specified "godoc" or "swag" as argument, show sample outputs and ask user to choose:

   Show this comparison:
   ```
   godoc:
   - Starts a local web server at http://localhost:6060
   - Interactive browser UI with all package docs
   - Supports search and navigation across all packages
   - Must be stopped manually with Ctrl+C
   - Best for: browsing and exploring Go package documentation

   swag:
   - Generates docs/swagger.yaml and docs/docs.go
   - OpenAPI 2.0 (Swagger) format
   - Requires @swagger annotations in your code comments
   - One-shot generation, no server needed
   - Best for: REST API documentation, OpenAPI tooling integration
   ```
   Then ask: "Which tool? (a) godoc or (b) swag"

3. Wait for user selection.
4. Run the docs-generate script:
   ```
   bash $CLAUDE_PLUGIN_ROOT/scripts/docs-generate.sh <godoc|swag>
   ```
5. For **godoc**: Tell the user "Documentation server running at http://localhost:6060 — open that URL in your browser. Press Ctrl+C in the terminal to stop."
6. For **swag**: Show the list of generated files. If swag fails with "no @swagger annotations", explain that swag requires `// @swagger` comments in handler functions and show a brief example annotation.
