#!/bin/bash

timestamp() {
    date +"%Y%m%d-%H%M%S"
}

setup_reports_dir() {
    mkdir -p "./go-checker-reports"
}

save_report() {
    local tool="$1"
    local content="$2"
    local report_file="./go-checker-reports/${tool}-$(timestamp).txt"
    printf '%s' "$content" > "$report_file"
    echo "Report saved: $report_file"
}

check_go_version() {
    local go_version
    go_version=$(go version 2>/dev/null | grep -oE 'go[0-9]+\.[0-9]+' | head -1 | sed 's/go//')
    if [ -z "$go_version" ]; then
        echo "ERROR: Go not found in PATH. Install Go from https://golang.org/dl/"
        exit 1
    fi

    local major minor
    major=$(echo "$go_version" | cut -d. -f1)
    minor=$(echo "$go_version" | cut -d. -f2)

    if [ "$major" -lt 1 ] || { [ "$major" -eq 1 ] && [ "$minor" -lt 21 ]; }; then
        echo "WARNING: Go $go_version detected. govulncheck requires Go 1.21+. vuln-scan will be skipped."
        export GOVULNCHECK_AVAILABLE=false
    else
        export GOVULNCHECK_AVAILABLE=true
    fi
}

check_install_tool() {
    local binary="$1"
    local import_path="$2"
    if ! command -v "$binary" &>/dev/null; then
        echo "Installing $binary..."
        if ! go install "${import_path}@latest"; then
            echo "ERROR: Failed to install $binary from $import_path"
            return 1
        fi
        echo "$binary installed."
    fi
}
