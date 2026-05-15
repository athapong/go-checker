#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PACKAGE="${1:-./...}"

check_go_version

if [ "$GOVULNCHECK_AVAILABLE" = "false" ]; then
    echo "Skipping vuln-scan: Go 1.21+ required for govulncheck."
    exit 0
fi

check_install_tool "govulncheck" "golang.org/x/vuln/cmd/govulncheck"

setup_reports_dir

echo "=== govulncheck ==="
echo "Package: $PACKAGE"
echo ""

output=$(govulncheck "$PACKAGE" 2>&1)
echo "$output"
save_report "vuln-scan" "$output"
