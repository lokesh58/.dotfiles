#!/usr/bin/env bash
set -euo pipefail

SERVER_URL="${1:-http://127.0.0.1:9931}"

# Exit immediately when systemd stops the service CGroup
trap 'kill $(jobs -p) 2>/dev/null || true; exit 0' TERM INT HUP

unload_model() {
    local model="$1"
    [ -n "$model" ] || return 0
    echo "Idle timeout reached for '$model' (entered sleeping state). Unloading to release CUDA context..."
    curl -fsS -X POST "$SERVER_URL/models/unload" \
        -H "Content-Type: application/json" \
        -d "{\"model\": \"$model\"}" >/dev/null || true
}

while true; do
    # Wait until the router server is reachable
    if ! curl -fsS "$SERVER_URL/v1/health" >/dev/null 2>&1; then
        sleep 2 &
        wait $! || true
        continue
    fi

    # Unload any models that might already be in the sleeping state
    sleeping_models=$(curl -fsS "$SERVER_URL/v1/models" 2>/dev/null \
        | jq -r '.data[]? | select(.status.value == "sleeping") | .id' 2>/dev/null || true)
    while IFS= read -r model; do
        unload_model "$model"
    done <<< "$sleeping_models"

    # Subscribe to the router's global SSE stream for real-time model state changes
    while IFS= read -r line; do
        if [[ "$line" == data:\ * ]]; then
            json="${line#data: }"
            model=$(jq -r 'select(.event == "status_change" and .data.status == "sleeping") | .model // empty' <<< "$json" 2>/dev/null || true)
            if [ -n "$model" ]; then
                unload_model "$model"
            fi
        fi
    done < <(curl -fsSN "$SERVER_URL/models/sse" 2>/dev/null || true)

    sleep 2 &
    wait $! || true
done
