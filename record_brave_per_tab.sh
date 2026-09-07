#!/usr/bin/env bash
# Records EACH brave sink-input (roughly = each audio-playing tab) to its own file.
# Per-tab auto-stop on: stream closed (tab closed / navigated away) OR silence.
set -uo pipefail

OUT_DIR="${1:-.}"
SILENCE_DB="-35dB"
SILENCE_DUR=10
POLL_INTERVAL=1

declare -A FFMPEG_PID SINK_MOD LOG_FILE TAIL_PID OUT_FILE

sanitize() {
    echo "$1" | tr -c 'A-Za-z0-9_-' '_' | sed 's/_\+/_/g; s/^_//; s/_$//'
}

# idx <TAB> media.name, brave sink-inputs only, robust to missing trailing blank line
parse_brave_inputs() {
    pactl list sink-inputs | awk '
        function flush() {
            if (idx != "" && (app ~ /[Bb]rave/ || bin ~ /brave/))
                printf "%s\t%s\n", idx, media
        }
        /^Sink Input #/ { flush(); idx=$3; sub("#","",idx); app=""; bin=""; media="" }
        /application\.name = /           { app=$0 }
        /application\.process\.binary = / { bin=$0 }
        /media\.name = / {
            media=$0
            sub(/^[^=]*= /,"",media)
            gsub(/"/,"",media)
        }
        END { flush() }
    '
}

start_recording() {
    local idx="$1" media="$2"
    local sink_name="brave_tab_${idx}"
    local mod
    mod=$(pactl load-module module-null-sink sink_name="$sink_name" sink_properties=device.description="BraveTab${idx}")
    pactl move-sink-input "$idx" "$sink_name" 2>/dev/null

    local tag; tag=$(sanitize "${media:-tab}")
    local outfile="${OUT_DIR}/brave_${idx}_${tag}_$(date +%H%M%S).wav"
    local logfile="/tmp/ffmpeg_brave_${idx}.log"

    ffmpeg -nostdin -f pulse -i "${sink_name}.monitor" \
        -af "silencedetect=noise=${SILENCE_DB}:d=${SILENCE_DUR}" \
        -y "$outfile" 2> "$logfile" &

    FFMPEG_PID[$idx]=$!
    SINK_MOD[$idx]=$mod
    LOG_FILE[$idx]=$logfile
    OUT_FILE[$idx]=$outfile
    echo "[start] idx=$idx media='${media}' -> $outfile (pid ${FFMPEG_PID[$idx]})"

    # per-tab silence watcher
    ( tail -n0 -F "$logfile" 2>/dev/null | while read -r line; do
        if [[ "$line" == *silence_start* ]]; then
            echo "[silence] idx=$idx quiet ${SILENCE_DUR}s+, stopping"
            kill "${FFMPEG_PID[$idx]}" 2>/dev/null
            break
        fi
    done ) &
    TAIL_PID[$idx]=$!
}

stop_recording() {
    local idx="$1" reason="$2"
    echo "[stop] idx=$idx reason=$reason -> ${OUT_FILE[$idx]:-?}"
    kill "${FFMPEG_PID[$idx]}" 2>/dev/null
    wait "${FFMPEG_PID[$idx]}" 2>/dev/null
    kill "${TAIL_PID[$idx]}" 2>/dev/null
    pactl unload-module "${SINK_MOD[$idx]}" 2>/dev/null
    rm -f "${LOG_FILE[$idx]}"
    unset 'FFMPEG_PID[$idx]' 'SINK_MOD[$idx]' 'LOG_FILE[$idx]' 'TAIL_PID[$idx]' 'OUT_FILE[$idx]'
}

cleanup() {
    echo "[cleanup] stopping all active tab recordings..."
    for idx in "${!FFMPEG_PID[@]}"; do
        stop_recording "$idx" "script exit"
    done
    exit 0
}
trap cleanup INT TERM EXIT

echo "[main] watching for brave tabs (Ctrl+C to stop all)..."
while true; do
    mapfile -t current < <(parse_brave_inputs)

    declare -A seen_now=()
    for row in "${current[@]}"; do
        [[ -z "$row" ]] && continue
        idx="${row%%$'\t'*}"
        media="${row#*$'\t'}"
        seen_now[$idx]=1
        if [[ -z "${FFMPEG_PID[$idx]:-}" ]]; then
            start_recording "$idx" "$media"
        fi
    done

    # any tracked idx no longer present -> its tab/stream closed
    for idx in "${!FFMPEG_PID[@]}"; do
        if [[ -z "${seen_now[$idx]:-}" ]]; then
            stop_recording "$idx" "stream closed"
        fi
    done
    unset seen_now

    sleep "$POLL_INTERVAL"
done
