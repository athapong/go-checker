#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PACKAGE="${1}"
STRUCT="${2}"

check_go_version
check_install_tool "structlayout" "honnef.co/go/tools/cmd/structlayout"
check_install_tool "structlayout-pretty" "honnef.co/go/tools/cmd/structlayout-pretty"
check_install_tool "structlayout-optimize" "honnef.co/go/tools/cmd/structlayout-optimize"

if [ -z "$PACKAGE" ] || [ -z "$STRUCT" ]; then
    echo "ERROR: Usage: struct-layout.sh <package> <StructName>"
    echo "Example: struct-layout.sh ./... MyStruct"
    echo "Example: struct-layout.sh example.com/pkg User"
    exit 0
fi

setup_reports_dir

echo "=== struct layout: $STRUCT in $PACKAGE ==="
echo ""

echo "--- Current layout ---"
current=$(structlayout -json "$PACKAGE" "$STRUCT" 2>&1 | structlayout-pretty 2>&1)
echo "$current"

echo ""
echo "--- Optimized layout (suggested field order) ---"
optimized=$(structlayout -json "$PACKAGE" "$STRUCT" 2>&1 | structlayout-optimize -r 2>&1 | structlayout-pretty 2>&1)
echo "$optimized"

output="=== struct layout: $STRUCT in $PACKAGE ===

--- Current layout ---
${current}

--- Optimized layout ---
${optimized}"

save_report "struct-layout" "$output"
