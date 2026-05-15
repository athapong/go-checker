#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PACKAGE="${1:-./...}"
BENCH_PATTERN="${2:-.}"

check_go_version
setup_reports_dir

echo "=== CPU Profiling ==="
echo "Package:  $PACKAGE"
echo "Bench:    $BENCH_PATTERN"
echo ""

rm -f cpu.prof

output=$(go test -bench="$BENCH_PATTERN" -cpuprofile=cpu.prof -benchtime=3s "$PACKAGE" 2>&1)
echo "$output"

if [ ! -f "cpu.prof" ]; then
    echo ""
    echo "NO_PROFILE_GENERATED"
    echo "No benchmarks matched pattern '$BENCH_PATTERN' in $PACKAGE."
    exit 0
fi

save_report "profile-cpu" "$output"

echo ""
echo "Opening pprof web UI at http://localhost:8080 ..."
go tool pprof -http=:8080 cpu.prof
