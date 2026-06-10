#!/usr/bin/env bash
set -euo pipefail

MODE_FILE="/tmp/game_mode_active"

ENTER() {
    touch "$MODE_FILE"

    # CPU policy
    powerprofilesctl set performance 2>/dev/null || true

    # GPU hint (safe, optional)
    GPU=$(find /sys/class/drm -name pp_power_profile_mode 2>/dev/null | head -n1)
    [[ -n "$GPU" ]] && echo "1" > "$GPU" 2>/dev/null || true

    # Hyprland: reduce effects
    hyprctl keyword animations:enabled false
    hyprctl keyword decoration:blur:enabled false
    hyprctl keyword general:gaps_in 0
    hyprctl keyword general:gaps_out 0

    # Set 144Hz (edit monitor name)
    hyprctl keyword monitor eDP-1,1920x1080@144,0x0,1

    notify-send "Game Mode" "ON"
}

EXIT() {
    rm -f "$MODE_FILE"

    powerprofilesctl set balanced 2>/dev/null || true

    GPU=$(find /sys/class/drm -name pp_power_profile_mode 2>/dev/null | head -n1)
    [[ -n "$GPU" ]] && echo "2" > "$GPU" 2>/dev/null || true

    hyprctl keyword animations:enabled true
    hyprctl keyword decoration:blur:enabled true

    hyprctl keyword monitor eDP-1,1920x1080@60,0x0,1

    notify-send "Game Mode" "OFF"
}

trap EXIT EXIT INT TERM

ENTER
"$@"
EXIT
