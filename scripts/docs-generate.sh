#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

TOOL="${1}"

check_go_version

if [ "$TOOL" = "godoc" ]; then
    check_install_tool "godoc" "golang.org/x/tools/cmd/godoc"
    echo "=== godoc ==="
    echo "Starting documentation server at http://localhost:6060"
    echo "Press Ctrl+C to stop."
    echo ""
    godoc -http=:6060

elif [ "$TOOL" = "swag" ]; then
    check_install_tool "swag" "github.com/swaggo/swag/cmd/swag"
    echo "=== swag ==="
    echo "Generating OpenAPI/Swagger documentation..."
    echo ""
    output=$(swag init 2>&1)
    echo "$output"
    echo ""
    if [ -d "docs" ]; then
        echo "Generated files:"
        ls -la docs/
    fi

else
    echo "ERROR: Specify tool: godoc or swag"
    exit 0
fi
