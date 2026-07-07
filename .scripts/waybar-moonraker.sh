#!/bin/bash
# filepath: ~/.scripts/waybar-moonraker.sh
# 3D printer (Klipper/Moonraker) status for waybar.
# Shows print progress while printing, hides itself when the printer is
# idle, off, or unreachable.
#
# Usage:  waybar-moonraker.sh          -> emit waybar JSON (used by exec)
#         waybar-moonraker.sh open     -> open the web UI (used by on-click)

# ----------------------- CONFIG -----------------------
ENABLED=1                                   # set to 0 to disable the module entirely
MOONRAKER_URL="http://192.168.1.100:7125"   # <- CHANGE ME: printer IP/hostname, Moonraker API port (7125)
WEB_UI_URL="http://192.168.1.100"           # <- CHANGE ME: what a click opens (Fluidd/Mainsail)
ICON="󰹛"
# -------------------------------------------------------

hide() { echo '{"text": "", "class": "hidden"}'; exit 0; }

[ "$ENABLED" = "1" ] || hide

if [ "$1" = "open" ]; then
    xdg-open "$WEB_UI_URL" >/dev/null 2>&1 &
    exit 0
fi

command -v curl >/dev/null 2>&1 || hide
command -v jq   >/dev/null 2>&1 || hide

json=$(curl -sf --max-time 3 \
    "$MOONRAKER_URL/printer/objects/query?print_stats&virtual_sdcard" 2>/dev/null)

# Printer powered off / unreachable / Klipper down -> hide
[ -n "$json" ] || hide

state=$(jq -r '.result.status.print_stats.state // "unknown"' <<<"$json")
progress=$(jq -r '.result.status.virtual_sdcard.progress // 0' <<<"$json")
filename=$(jq -r '.result.status.print_stats.filename // ""' <<<"$json")
duration=$(jq -r '.result.status.print_stats.print_duration // 0' <<<"$json")

# keep the JSON we emit valid
filename=${filename//\\/}
filename=${filename//\"/}

pct=$(awk -v p="$progress" 'BEGIN { printf "%d", p * 100 }')

fmt_time() {
    awk -v s="$1" 'BEGIN { s = int(s); printf "%dh%02dm", s / 3600, (s % 3600) / 60 }'
}

case "$state" in
    printing)
        eta=""
        if awk -v p="$progress" 'BEGIN { exit !(p > 0.01) }'; then
            remaining=$(awk -v d="$duration" -v p="$progress" 'BEGIN { printf "%d", d / p - d }')
            eta=", ~$(fmt_time "$remaining") left"
        fi
        printf '{"text": "%s %s%%", "tooltip": "Printing: %s\\n%s%% done, %s elapsed%s", "class": "printing", "percentage": %s}\n' \
            "$ICON" "$pct" "$filename" "$pct" "$(fmt_time "$duration")" "$eta" "$pct"
        ;;
    paused)
        printf '{"text": "%s %s%%", "tooltip": "Paused: %s (%s%%)", "class": "paused", "percentage": %s}\n' \
            "$ICON" "$pct" "$filename" "$pct" "$pct"
        ;;
    complete)
        printf '{"text": "%s done", "tooltip": "Print complete: %s", "class": "done"}\n' \
            "$ICON" "$filename"
        ;;
    error)
        printf '{"text": "%s err", "tooltip": "Printer error - check Klipper", "class": "error"}\n' \
            "$ICON"
        ;;
    *)  # standby etc.
        hide
        ;;
esac
