#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PACKAGE="${1:-./...}"

check_go_version
check_install_tool "gosec" "github.com/securego/gosec/v2/cmd/gosec"

setup_reports_dir

echo "=== gosec security scan ==="
echo "Package: $PACKAGE"
echo ""

output=$(gosec "$PACKAGE" 2>&1)
echo "$output"
save_report "security-scan" "$output"
