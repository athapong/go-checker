#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

TARGET="$1"

check_go_version
check_install_tool "gotests" "github.com/cweill/gotests/gotests"

if [ -z "$TARGET" ]; then
    echo "ERROR: No target specified."
    echo "Usage: test-scaffold.sh <file.go|./package/path>"
    exit 0
fi

echo "=== gotests ==="
echo "Target: $TARGET"
echo ""

output=$(gotests -all -w "$TARGET" 2>&1)
echo "$output"
