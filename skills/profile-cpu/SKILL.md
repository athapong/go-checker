---
name: Go CPU Profiling
description: Use when the user wants to profile Go CPU performance, run benchmarks, or analyze CPU hotspots. Trigger on phrases "profile", "cpu performance", "pprof cpu", "benchmark", "cpu profiling". Runs go test -bench and opens pprof web UI.
argument-hint: "[package path] [bench pattern]"
allowed-tools: Bash
---

Profile CPU performance in a Go repository using go test and pprof.

1. Run the go-tool-installer agent to verify the environment.
2. Determine package scope: use argument if provided, otherwise `./...`.
3. Run the CPU profile script with default bench pattern `.`:
   ```
   bash $CLAUDE_PLUGIN_ROOT/scripts/profile-cpu.sh [package] [bench-pattern]
   ```
4. Check output:
   - If output contains `NO_PROFILE_GENERATED`: no benchmarks exist. Ask the user:
     > "No benchmarks found in [package]. To profile, I need either:
     > (a) A bench pattern — which benchmark function to run? (e.g. BenchmarkMyFunc)
     > (b) A compiled binary path — provide the path to run with pprof directly"
     Then wait for user input and re-run with their specified flags.
   - If `cpu.prof` was generated: pprof web UI opens at http://localhost:8080. Tell the user to open that URL and press Ctrl+C in the terminal when done.
5. Tell the user raw benchmark output was saved to `./go-checker-reports/profile-cpu-<timestamp>.txt`.
