#!/usr/bin/env bash
# Records all audio streams from Brave, auto-stops on stream-close OR prolonged silence.
set -uo pipefail

OUT_WAV="${1:-brave_$(date +%Y%m%d_%H%M%S).wav}"
NULL_SINK="brave_capture"
SILENCE_DB="-35dB"
SILENCE_DUR=10   # seconds of silence before auto-stop
POLL_INTERVAL=1

cleanup() {
    echo "[cleanup] stopping..."
    [[ -n "${FFMPEG_PID:-}" ]] && kill "$FFMPEG_PID" 2>/dev/null
    [[ -n "${SUBSCRIBE_PID:-}" ]] && kill "$SUBSCRIBE_PID" 2>/dev/null
    [[ -n "${WATCH_PID:-}" ]] && kill "$WATCH_PID" 2>/dev/null
    if [[ -n "${MODULE_ID:-}" ]]; then
        pactl unload-module "$MODULE_ID" 2>/dev/null
    fi
    wait "$FFMPEG_PID" 2>/dev/null
    echo "[cleanup] saved: $OUT_WAV"
    exit 0
}
trap cleanup INT TERM EXIT

# 1. null sink to route all Brave streams into
MODULE_ID=$(pactl load-module module-null-sink sink_name="$NULL_SINK" sink_properties=device.description="BraveCapture")
echo "[setup] null sink loaded, module id $MODULE_ID"

# find sink-input indexes belonging to brave (matches application.name or process.binary)
find_brave_inputs() {
    pactl list sink-inputs | awk '
        function flush() {
            if (idx != "" && (app ~ /[Bb]rave/ || bin ~ /brave/)) print idx
        }
        /^Sink Input #/ { flush(); idx=$3; sub("#","",idx); app=""; bin="" }
        /application\.name = /   { app=$0 }
        /application\.process\.binary = / { bin=$0 }
        END { flush() }
    '
}

# move any current + future brave streams onto the null sink, continuously
watch_and_route() {
    while true; do
        for idx in $(find_brave_inputs); do
            pactl move-sink-input "$idx" "$NULL_SINK" 2>/dev/null
        done
        sleep "$POLL_INTERVAL"
    done
}
watch_and_route &
WATCH_PID=$!

# 2. hard-stop watcher: if brave has zero active streams for a grace period, stop
subscribe_watch() {
    local grace=5 empty_since=0 seen_one=0
    while true; do
        count=$(find_brave_inputs | wc -l)
        if [[ "$count" -gt 0 ]]; then
            seen_one=1
            empty_since=0
        elif [[ "$seen_one" -eq 1 ]]; then
            empty_since=$((empty_since + POLL_INTERVAL))
            if [[ "$empty_since" -ge "$grace" ]]; then
                echo "[watch] no brave streams left, stopping"
                kill "$FFMPEG_PID" 2>/dev/null
                break
            fi
        fi
        sleep "$POLL_INTERVAL"
    done
}

# 3. record null sink's monitor, with silencedetect for soft auto-stop
ffmpeg -nostdin -f pulse -i "${NULL_SINK}.monitor" \
    -af "silencedetect=noise=${SILENCE_DB}:d=${SILENCE_DUR}" \
    -y "$OUT_WAV" 2> >(tee /tmp/ffmpeg_brave.log >&2) &
FFMPEG_PID=$!
echo "[record] ffmpeg pid $FFMPEG_PID -> $OUT_WAV"

subscribe_watch &
SUBSCRIBE_PID=$!

# soft-stop watcher: tail ffmpeg log for silence_start
( tail -n0 -F /tmp/ffmpeg_brave.log & echo $! > /tmp/tail_brave.pid ) | \
while read -r line; do
    if [[ "$line" == *silence_start* ]]; then
        echo "[watch] silence >= ${SILENCE_DUR}s detected, stopping"
        kill "$FFMPEG_PID" 2>/dev/null
        break
    fi
done &

wait "$FFMPEG_PID"
