#!/usr/bin/env bash

set -euo pipefail

HI_CRIT=84
MED_WARN=74
LO_RECOVER=64

POLL_INTERVAL=2
CURRENT_GEAR=3

GPU_PATH=$(find /sys/class/drm -name power_dpm_force_performance_level 2>/dev/null | head -n1)

get_cpu_temp() {
    sensors 2>/dev/null |
        awk '/Tctl:/ {
            gsub(/[+°C]/,"",$2)
            print int($2)
            exit
        }'
}

get_gpu_temp() {
    sensors 2>/dev/null |
        awk '/edge:/ {
            gsub(/[+°C]/,"",$2)
            print int($2)
            exit
        }'
}

set_epp() {
    local mode="$1"

    for p in /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference; do
        [[ -w "$p" ]] && echo "$mode" > "$p"
    done
}

set_gear1() {
    [[ -n "$GPU_PATH" ]] &&
        echo low > "$GPU_PATH"

    set_epp power

    command -v ryzenadj >/dev/null &&
        ryzenadj \
            --stapm-limit=10000 \
            --fast-limit=10000 \
            --slow-limit=10000 \
            >/dev/null 2>&1

    CURRENT_GEAR=1

    notify-send -u critical \
        "Thermal Watchdog" \
        "Temperature ${MAX_TEMP}°C → Gear 1"
}

set_gear2() {
    [[ -n "$GPU_PATH" ]] &&
        echo auto > "$GPU_PATH"

    set_epp balance_power

    command -v ryzenadj >/dev/null &&
        ryzenadj \
            --stapm-limit=15000 \
            --fast-limit=15000 \
            --slow-limit=15000 \
            >/dev/null 2>&1

    CURRENT_GEAR=2

    notify-send \
        "Thermal Watchdog" \
        "Temperature ${MAX_TEMP}°C → Gear 2"
}

set_gear3() {
    [[ -n "$GPU_PATH" ]] &&
        echo auto > "$GPU_PATH"

    set_epp balance_performance

    command -v ryzenadj >/dev/null &&
        ryzenadj \
            --stapm-limit=35000 \
            --fast-limit=35000 \
            --slow-limit=35000 \
            >/dev/null 2>&1

    CURRENT_GEAR=3

    notify-send \
        "Thermal Watchdog" \
        "Temperature ${MAX_TEMP}°C → Gear 3"
}

cleanup() {
    set_gear3
}

trap cleanup EXIT INT TERM

while true; do
    CPU_C=$(get_cpu_temp)
    GPU_C=$(get_gpu_temp)

    CPU_C=${CPU_C:-0}
    GPU_C=${GPU_C:-0}

    (( CPU_C > GPU_C )) && MAX_TEMP=$CPU_C || MAX_TEMP=$GPU_C

    if (( MAX_TEMP >= HI_CRIT && CURRENT_GEAR != 1 )); then
        set_gear1

    elif (( MAX_TEMP >= MED_WARN &&
            MAX_TEMP < HI_CRIT &&
            CURRENT_GEAR == 3 )); then
        set_gear2

    elif (( MAX_TEMP <= LO_RECOVER &&
            CURRENT_GEAR != 3 )); then
        set_gear3
    fi

    sleep "$POLL_INTERVAL"
done
