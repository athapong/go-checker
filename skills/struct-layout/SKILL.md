---
name: Go Struct Layout
description: Use when the user asks about Go struct memory layout, field alignment, padding, struct size optimization, or memory efficiency of structs. Trigger on phrases "struct layout", "memory layout", "struct padding", "struct alignment", "struct size", "optimize struct", "struct memory", "field ordering", "struct optimization". Shows current field layout with sizes and offsets, then suggests optimal field ordering to minimize padding.
argument-hint: "[package] [StructName]"
allowed-tools: Bash
---

Analyze Go struct memory layout and suggest optimizations using structlayout.

1. Run the go-tool-installer agent to verify the environment.
2. If the user did not provide both package and struct name, ask:
   > "Which struct to analyze?
   > - Package path (e.g. `./internal/models` or `example.com/pkg`)
   > - Struct name (e.g. `User`, `Request`)"
3. Run the struct layout script:
   ```
   bash $CLAUDE_PLUGIN_ROOT/scripts/struct-layout.sh <package> <StructName>
   ```
4. Show the full output: current layout then optimized layout.
5. Explain the output to the user:
   - Each field shows: name, type, size (bytes), offset (bytes from struct start), and any padding
   - Padding bytes are wasted space caused by alignment requirements
   - The optimized layout reorders fields to pack them tighter (largest alignment first)
6. If optimized layout differs from current:
   - Calculate total size reduction: `current_size - optimized_size` bytes saved
   - Tell the user: "Reordering fields as shown saves N bytes per struct instance. At scale (e.g. 1M instances), that's N MB."
   - Show the suggested field declaration order as a Go struct snippet
7. If no padding exists (layout already optimal), tell the user: "Struct is already optimally packed — no padding waste."
8. Tell the user the report was saved to `./go-checker-reports/struct-layout-<timestamp>.txt`.

**Background for explanations:**
- Go aligns each field to its natural alignment (bool=1, int32=4, int64=8, pointer=8 on 64-bit)
- The compiler inserts padding bytes between fields to satisfy alignment
- Reordering fields largest-to-smallest alignment typically eliminates padding
- `structlayout-optimize` uses a greedy algorithm: sorts fields by alignment descending, then by size descending
