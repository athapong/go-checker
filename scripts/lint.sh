#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PACKAGE="${1:-./...}"

check_go_version
check_install_tool "golangci-lint" "github.com/golangci/golangci-lint/cmd/golangci-lint"

setup_reports_dir

CONFIG_MSG="default config"
if [ -f ".golangci.yml" ]; then
    CONFIG_MSG=".golangci.yml"
fi

echo "=== golangci-lint ==="
echo "Package: $PACKAGE"
echo "Config:  $CONFIG_MSG"
echo ""

output=$(golangci-lint run "$PACKAGE" 2>&1)
echo "$output"
save_report "lint" "$output"
