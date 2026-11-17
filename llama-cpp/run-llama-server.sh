#!/usr/bin/env bash
set -euo pipefail

GGUF_ROOT="${1:?Usage: $0 <gguf-root> <preset-ini>}"
PRESET_INI="${2:?Usage: $0 <gguf-root> <preset-ini>}"

for cmd in llama-server llama-preset-gen llama-idle-unloader; do
    command -v "$cmd" >/dev/null || { echo "Error: $cmd not found in PATH." >&2; exit 1; }
done

[ -d "$GGUF_ROOT" ] || { echo "Error: GGUF root not found: $GGUF_ROOT" >&2; exit 1; }
mkdir -p "$(dirname "$PRESET_INI")"

# 1. Cleanup Trap
UNLOADER_PID=""
SERVER_PID=""
cleanup() {
    # ask both children to stop (TERM = what systemd stop / launchctl bootout send)
    [ -n "$UNLOADER_PID" ] && kill -TERM "$UNLOADER_PID" 2>/dev/null || true
    [ -n "$SERVER_PID" ]   && kill -TERM "$SERVER_PID"   2>/dev/null || true

    # reap them so we don't exit while children are still alive
    [ -n "$UNLOADER_PID" ] && wait "$UNLOADER_PID" 2>/dev/null || true
    [ -n "$SERVER_PID" ]   && wait "$SERVER_PID"   2>/dev/null || true
}
trap cleanup EXIT
trap 'exit 143' TERM
trap 'exit 130' INT
trap 'exit 129' HUP

# 2. Pre-Start: Preset Generation
llama-preset-gen "$GGUF_ROOT" "$PRESET_INI"

# 3. Post-Start: Unloader Sidecar (Background)
llama-idle-unloader "http://127.0.0.1:9931" &
UNLOADER_PID=$!

# 4. Start Server (Background to allow trap handling)
llama-server \
    --host 127.0.0.1 \
    --port 9931 \
    --models-dir "$GGUF_ROOT" \
    --models-preset "$PRESET_INI" \
    --sleep-idle-seconds 300 \
    --fit-ctx 131072 \
    --flash-attn auto &
SERVER_PID=$!

# Wait for server to exit
wait "$SERVER_PID"
