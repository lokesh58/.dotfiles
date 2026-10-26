#!/usr/bin/env bash
set -euo pipefail

GGUF_DIR="${1:?Usage: $0 /path/to/gguf /path/to/output.ini}"
MERGED_INI="${2:?Usage: $0 /path/to/gguf /path/to/output.ini}"

# Start with an empty file (avoid top-level keys before sections)
> "$MERGED_INI"

# Enable nullglob so the loop exits cleanly if no preset.ini files exist yet
shopt -s nullglob
for preset in "$GGUF_DIR"/*/preset.ini; do
  model_name=$(basename "$(dirname "$preset")")
  echo "[$model_name]" >> "$MERGED_INI"
  # Copy all lines except accidental [section] headers
  grep -v '^\s*\[' "$preset" >> "$MERGED_INI" || true
  echo "" >> "$MERGED_INI"
done
