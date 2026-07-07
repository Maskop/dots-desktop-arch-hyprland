#!/bin/bash
# filepath: ~/.config/wofi/scripts/bluetooth_menu.sh
# Bluetooth dropdown for waybar, in the same spirit as wifi_menu.sh.
# Toggle power, connect/disconnect known devices, scan & pair new ones.

ICON_ON="󰂯"
ICON_OFF="󰂲"
ICON_CONNECTED="󰂱"
ICON_SCAN="󰀘"

is_powered() {
    bluetoothctl show 2>/dev/null | grep -q "Powered: yes"
}

toggle_power() {
    if is_powered; then
        bluetoothctl power off >/dev/null 2>&1
        notify-send "Bluetooth" "Bluetooth has been disabled" --icon=bluetooth-disabled
    else
        rfkill unblock bluetooth 2>/dev/null
        bluetoothctl power on >/dev/null 2>&1
        notify-send "Bluetooth" "Bluetooth has been enabled" --icon=bluetooth-active
    fi
}

is_connected() {
    bluetoothctl info "$1" 2>/dev/null | grep -q "Connected: yes"
}

# Known devices as "MAC<space>NAME", one per line
get_devices() {
    bluetoothctl devices 2>/dev/null | sed -n 's/^Device \([0-9A-Fa-f:]\{17\}\) \(.*\)$/\1 \2/p'
}

device_menu_entries() {
    local mac name
    while read -r mac name; do
        [ -z "$mac" ] && continue
        if is_connected "$mac"; then
            echo "$ICON_CONNECTED $name ($mac)"
        else
            echo "$ICON_ON $name ($mac)"
        fi
    done < <(get_devices)
}

extract_mac() {
    grep -oE '([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}' <<<"$1" | head -n1
}

extract_name() {
    # strip leading "<icon> " and trailing " (MAC)"
    local s="${1#* }"
    echo "${s% (*}"
}

toggle_device() {
    local mac="$1" name="$2"
    if is_connected "$mac"; then
        if bluetoothctl disconnect "$mac" >/dev/null 2>&1; then
            notify-send "Bluetooth" "Disconnected from $name" --icon=bluetooth-active
        else
            notify-send "Bluetooth Error" "Failed to disconnect from $name" --icon=dialog-error
        fi
    else
        notify-send "Bluetooth" "Connecting to $name..." --urgency=low --icon=bluetooth-active
        if bluetoothctl connect "$mac" >/dev/null 2>&1; then
            notify-send "Bluetooth" "Connected to $name" --icon=bluetooth-active
        else
            notify-send "Bluetooth Error" "Failed to connect to $name" --icon=dialog-error
        fi
    fi
}

scan_and_pair() {
    notify-send "Bluetooth" "Scanning for devices (10s)..." --urgency=low --icon=bluetooth-active
    bluetoothctl --timeout 10 scan on >/dev/null 2>&1

    local selected
    selected=$( { echo "  Back"; device_menu_entries; } | wofi --dmenu -i -p "Pair device")

    if [ -z "$selected" ] || [[ "$selected" == *"Back"* ]]; then
        bluetooth_menu
        return
    fi

    local mac name
    mac=$(extract_mac "$selected")
    name=$(extract_name "$selected")

    if [ -z "$mac" ]; then
        bluetooth_menu
        return
    fi

    if is_connected "$mac"; then
        toggle_device "$mac" "$name"
        return
    fi

    notify-send "Bluetooth" "Pairing with $name..." --urgency=low --icon=bluetooth-active
    bluetoothctl pair "$mac" >/dev/null 2>&1
    bluetoothctl trust "$mac" >/dev/null 2>&1

    if bluetoothctl connect "$mac" >/dev/null 2>&1; then
        notify-send "Bluetooth" "Paired and connected to $name" --icon=bluetooth-active
    else
        notify-send "Bluetooth Error" "Failed to pair/connect to $name" --icon=dialog-error
    fi
}

bluetooth_menu() {
    local selected entries

    if ! is_powered; then
        selected=$(echo "$ICON_OFF Power: off (select to enable)" | wofi --dmenu -i -p "Bluetooth")
        if [ -n "$selected" ]; then
            toggle_power
            bluetooth_menu
        fi
        return
    fi

    entries=$(device_menu_entries)
    [ -z "$entries" ] && entries="(no paired devices yet - use scan)"

    selected=$(printf '%s\n%s\n%s\n' \
        "$ICON_ON Power: on (select to disable)" \
        "$ICON_SCAN Scan / pair new device" \
        "$entries" | wofi --dmenu -i -p "Bluetooth")

    [ -z "$selected" ] && return

    case "$selected" in
        *"Power:"*)
            toggle_power
            bluetooth_menu
            ;;
        *"Scan / pair"*)
            scan_and_pair
            ;;
        *"no paired devices"*)
            bluetooth_menu
            ;;
        *)
            local mac name
            mac=$(extract_mac "$selected")
            name=$(extract_name "$selected")
            [ -n "$mac" ] && toggle_device "$mac" "$name"
            ;;
    esac
}

bluetooth_menu
