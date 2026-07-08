#!/bin/bash
# filepath: ~/.scripts/waybar-printers.sh
# 3D printer status for waybar. Supports multiple printers at once:
#   - moonraker : Klipper printers (Neptune 4 Pro, Voron, ...)
#   - prusalink : Original Prusa printers (MK4/S, MK3.5/3.9, MINI, XL, CORE One)
# Shows print progress while printing, hides itself when every printer is
# idle, off, or unreachable.
#
# Usage:  waybar-printers.sh          -> emit waybar JSON (used by exec)
#         waybar-printers.sh open     -> open web UI of the active printer

# ----------------------------- CONFIG -----------------------------
ENABLED=1        # set to 0 to disable the module entirely
ICON="󰹛"

# One printer per entry:  "NAME|TYPE|API_URL|WEB_URL|AUTH"
#   TYPE : moonraker | prusalink
#   AUTH : moonraker -> leave empty
#          prusalink -> API key (printer LCD: Settings -> Network -> PrusaLink),
#                       or "user:password" to use HTTP digest auth instead
#                       (Pi-based PrusaLink on MK3)
PRINTERS=(
    "neptune|moonraker|http://192.168.1.100:7125|http://192.168.1.100|"
    # "voron|moonraker|http://192.168.1.101:7125|http://192.168.1.101|"
    # "mk4|prusalink|http://192.168.1.102|http://192.168.1.102|YOUR_API_KEY"
)
# -------------------------------------------------------------------

hide() { echo '{"text": "", "class": "hidden"}'; exit 0; }

[ "$ENABLED" = "1" ] || hide
command -v curl >/dev/null 2>&1 || hide
command -v jq   >/dev/null 2>&1 || hide

fmt_time() {
    awk -v s="$1" 'BEGIN { s = int(s); printf "%dh%02dm", s / 3600, (s % 3600) / 60 }'
}

sanitize() {
    local s="${1//\\/}"
    s="${s//\"/}"
    echo "${s//|/-}"
}

# Each query_* function sets: R_STATE (printing|paused|done|error|idle),
# R_PCT, R_FILE, R_ELAPSED, R_REMAIN. Returns non-zero when unreachable.

query_moonraker() {
    local url="$1" json state prog
    json=$(curl -sf --max-time 3 \
        "$url/printer/objects/query?print_stats&virtual_sdcard" 2>/dev/null) || return 1
    [ -n "$json" ] || return 1

    state=$(jq -r '.result.status.print_stats.state // "unknown"' <<<"$json")
    prog=$(jq -r '.result.status.virtual_sdcard.progress // 0' <<<"$json")
    R_FILE=$(sanitize "$(jq -r '.result.status.print_stats.filename // ""' <<<"$json")")
    R_ELAPSED=$(jq -r '.result.status.print_stats.print_duration // 0' <<<"$json")
    R_PCT=$(awk -v p="$prog" 'BEGIN { printf "%d", p * 100 }')

    R_REMAIN=0
    if awk -v p="$prog" 'BEGIN { exit !(p > 0.01) }'; then
        R_REMAIN=$(awk -v d="$R_ELAPSED" -v p="$prog" 'BEGIN { printf "%d", d / p - d }')
    fi

    case "$state" in
        printing) R_STATE="printing" ;;
        paused)   R_STATE="paused" ;;
        complete) R_STATE="done" ;;
        error)    R_STATE="error" ;;
        *)        R_STATE="idle" ;;
    esac
}

query_prusalink() {
    local url="$1" auth="$2" json jjson state
    local -a auth_args=()
    if [[ "$auth" == *:* ]]; then
        auth_args=(--digest -u "$auth")
    elif [ -n "$auth" ]; then
        auth_args=(-H "X-Api-Key: $auth")
    fi

    json=$(curl -sf --max-time 3 "${auth_args[@]}" "$url/api/v1/status" 2>/dev/null) || return 1
    [ -n "$json" ] || return 1

    state=$(jq -r '.printer.state // "UNKNOWN"' <<<"$json")
    R_PCT=$(jq -r '.job.progress // 0' <<<"$json")
    R_PCT=${R_PCT%.*}       # PrusaLink reports 0-100, possibly as float
    [ -n "$R_PCT" ] || R_PCT=0
    R_REMAIN=$(jq -r '.job.time_remaining // 0' <<<"$json")
    R_ELAPSED=$(jq -r '.job.time_printing // 0' <<<"$json")
    R_FILE=""

    case "$state" in
        PRINTING)  R_STATE="printing" ;;
        PAUSED)    R_STATE="paused" ;;
        ATTENTION) R_STATE="paused" ;;   # filament change / needs user
        FINISHED)  R_STATE="done" ;;
        ERROR)     R_STATE="error" ;;
        *)         R_STATE="idle" ;;
    esac

    if [ "$R_STATE" = "printing" ] || [ "$R_STATE" = "paused" ]; then
        jjson=$(curl -sf --max-time 3 "${auth_args[@]}" "$url/api/v1/job" 2>/dev/null)
        [ -n "$jjson" ] && \
            R_FILE=$(sanitize "$(jq -r '.file.display_name // .file.name // ""' <<<"$jjson")")
    fi
}

# ---- collect status of every configured printer ----
NAMES=() STATES=() PCTS=() FILES=() ELAPSEDS=() REMAINS=() WEBS=()

collect() {
    local entry name type api web auth
    for entry in "${PRINTERS[@]}"; do
        IFS='|' read -r name type api web auth <<<"$entry"
        [ -n "$name" ] && [ -n "$api" ] || continue

        R_STATE="" R_PCT=0 R_FILE="" R_ELAPSED=0 R_REMAIN=0
        case "$type" in
            moonraker) query_moonraker "$api" || continue ;;
            prusalink) query_prusalink "$api" "$auth" || continue ;;
            *) continue ;;
        esac

        NAMES+=("$name"); STATES+=("$R_STATE"); PCTS+=("$R_PCT")
        FILES+=("$R_FILE"); ELAPSEDS+=("$R_ELAPSED"); REMAINS+=("$R_REMAIN")
        WEBS+=("$web")
    done
}

collect

# ---- on-click: open the web UI of the busiest printer ----
if [ "$1" = "open" ]; then
    for i in "${!NAMES[@]}"; do
        case "${STATES[$i]}" in
            printing|paused|error)
                [ -n "${WEBS[$i]}" ] && xdg-open "${WEBS[$i]}" >/dev/null 2>&1 &
                exit 0
                ;;
        esac
    done
    # nothing active -> first configured printer
    IFS='|' read -r _ _ _ web _ <<<"${PRINTERS[0]}"
    [ -n "$web" ] && xdg-open "$web" >/dev/null 2>&1 &
    exit 0
fi

# ---- build waybar JSON ----
parts=() tooltip="" class="" pctfield="" have_done=0

rank() {
    case "$1" in
        error) echo 4 ;; paused) echo 3 ;; printing) echo 2 ;; done) echo 1 ;; *) echo 0 ;;
    esac
}

add_tip() {
    tooltip="${tooltip}${tooltip:+\\n}$1"
}

for i in "${!NAMES[@]}"; do
    name="${NAMES[$i]}" state="${STATES[$i]}" pct="${PCTS[$i]}"
    file="${FILES[$i]}" elapsed="${ELAPSEDS[$i]}" remain="${REMAINS[$i]}"

    case "$state" in
        printing)
            parts+=("${pct}%")
            eta=""
            [ "$remain" -gt 0 ] 2>/dev/null && eta=", ~$(fmt_time "$remain") left"
            add_tip "$name: printing $file - ${pct}%, $(fmt_time "$elapsed") elapsed$eta"
            [ -z "$pctfield" ] && pctfield=", \"percentage\": $pct"
            ;;
        paused)
            parts+=("${pct}%")
            add_tip "$name: paused $file (${pct}%)"
            [ -z "$pctfield" ] && pctfield=", \"percentage\": $pct"
            ;;
        error)
            parts+=("!")
            add_tip "$name: error - check printer"
            ;;
        done)
            have_done=1
            add_tip "$name: print finished ($file)"
            ;;
        *) continue ;;
    esac

    if [ "$(rank "$state")" -gt "$(rank "$class")" ]; then
        class="$state"
    fi
done

[ -n "$tooltip" ] || hide

if [ "${#parts[@]}" -gt 0 ]; then
    text="$ICON ${parts[*]}"
elif [ "$have_done" = "1" ]; then
    text="$ICON done"
else
    hide
fi

printf '{"text": "%s", "tooltip": "%s", "class": "%s"%s}\n' \
    "$text" "$tooltip" "$class" "$pctfield"
