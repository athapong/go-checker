#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

MODE="${1}"

check_go_version
setup_reports_dir

if [ -z "$MODE" ]; then
    echo "ERROR: No mode specified. Use: verify | tidy | both"
    exit 0
fi

output=""

if [ "$MODE" = "verify" ] || [ "$MODE" = "both" ]; then
    echo "=== go mod verify ==="
    verify_out=$(go mod verify 2>&1)
    echo "$verify_out"
    output+="=== go mod verify ===\n${verify_out}\n\n"
fi

if [ "$MODE" = "tidy" ] || [ "$MODE" = "both" ]; then
    echo "=== go mod tidy ==="
    tidy_out=$(go mod tidy 2>&1)
    echo "$tidy_out"
    output+="=== go mod tidy ===\n${tidy_out}\n"
fi

save_report "deps-verify" "$(printf '%b' "$output")"
