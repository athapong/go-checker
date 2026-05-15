#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PACKAGE="${1:-./...}"

check_go_version
setup_reports_dir

echo "=== go test -race ==="
echo "Package: $PACKAGE"
echo ""

output=$(go test -race "$PACKAGE" 2>&1)
echo "$output"
save_report "race-check" "$output"
