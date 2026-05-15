---
name: Go Memory Profiling
description: Use when the user wants to profile Go memory usage, heap allocations, or memory leaks. Trigger on phrases "memory profile", "heap", "pprof memory", "memory usage", "allocations", "memory leak". Runs go test -bench with memprofile and opens pprof web UI.
argument-hint: "[package path] [bench pattern]"
allowed-tools: Bash
---

Profile memory usage in a Go repository using go test and pprof.

1. Run the go-tool-installer agent to verify the environment.
2. Determine package scope: use argument if provided, otherwise `./...`.
3. Run the memory profile script with default bench pattern `.`:
   ```
   bash $CLAUDE_PLUGIN_ROOT/scripts/profile-memory.sh [package] [bench-pattern]
   ```
4. Check output:
   - If output contains `NO_PROFILE_GENERATED`: no benchmarks exist. Ask the user:
     > "No benchmarks found in [package]. To profile memory, I need either:
     > (a) A bench pattern — which benchmark function to run? (e.g. BenchmarkMyFunc)
     > (b) A compiled binary path — provide the path to run with pprof directly"
     Then wait for user input and re-run with their specified flags.
   - If `mem.prof` was generated: pprof web UI opens at http://localhost:8080. Tell the user to open that URL and press Ctrl+C in the terminal when done.
5. Tell the user raw benchmark output was saved to `./go-checker-reports/profile-memory-<timestamp>.txt`.
