#!/usr/bin/env bash

# YOUR 3 CUSTOM TEMPERATURE TARGETS
HI_CRIT=84
MED_WARN=74
LO_RECOVER=64

POLL_INTERVAL=2
CURRENT_GEAR=3

while true; do
    # 1. Grab the highest current temperature (CPU or GPU)
    GPU_C=$(sensors | grep -E 'edge|junction' | awk '{print $2}' | tr -d '+°C' | cut -d. -f1 | head -n1)
    CPU_C=$(sensors | grep -i 'Tctl' | awk '{print $2}' | tr -d '+°C' | cut -d. -f1)
    MAX_TEMP=$(( GPU_C > CPU_C ? GPU_C : CPU_C ))

    # 2. GEAR STATE MACHINE

    # CRITICAL: Hit 85°C -> Drop to Gear 1 (Max cooling, low FPS)
    if [ "$MAX_TEMP" -ge "$HI_CRIT" ] && [ "$CURRENT_GEAR" -ne 1 ]; then
        echo "low" > /sys/class/drm/card2/device/power_dpm_force_performance_level
        echo "power" | tee /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference &>/dev/null
        if command -v ryzenadj &>/dev/null; then ryzenadj --stapm-limit=10000 --fast-limit=10000 --slow-limit=10000 &>/dev/null; fi
        CURRENT_GEAR=1
        notify-send -u critical "Thermal Watchdog" "Hit $MAX_TEMP°C! Dropping to Gear 1 (Low Power Mode)."

    # WARNING: Hit 74°C (or recovering from Gear 1) -> Drop/Raise to Gear 2 (Smooth 144Hz, restricted CPU)
    elif [ "$MAX_TEMP" -ge "$MED_WARN" ] && [ "$MAX_TEMP" -lt "$HI_CRIT" ] && [ "$CURRENT_GEAR" -eq 3 ]; then
        echo "auto" > /sys/class/drm/card2/device/power_dpm_force_performance_level
        echo "balance_power" | tee /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference &>/dev/null
        if command -v ryzenadj &>/dev/null; then ryzenadj --stapm-limit=15000 --fast-limit=15000 --slow-limit=15000 &>/dev/null; fi
        CURRENT_GEAR=2
        notify-send "Thermal Watchdog" "Hit $MAX_TEMP°C! Shifting to Gear 2 (Balanced 144Hz)."

    # RECOVERY: Cools all the way down to 64°C -> Unleash Gear 3 (Full performance)
    elif [ "$MAX_TEMP" -le "$LO_RECOVER" ] && [ "$CURRENT_GEAR" -ne 3 ]; then
        echo "auto" > /sys/class/drm/card2/device/power_dpm_force_performance_level
        echo "balance_performance" | tee /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference &>/dev/null
        if command -v ryzenadj &>/dev/null; then ryzenadj --stapm-limit=35000 --fast-limit=35000 --slow-limit=35000 &>/dev/null; fi
        CURRENT_GEAR=3
        notify-send "Thermal Watchdog" "Cooled to $MAX_TEMP°C. Gear 3 Unleashed (Full Power 144Hz)!"
    fi

    sleep $POLL_INTERVAL
done
