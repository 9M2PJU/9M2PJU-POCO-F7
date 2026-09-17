#!/usr/bin/env bash
# ==============================================================================
# POCO F7 Performance & Health Optimizer
# Repo: https://github.com/9M2PJU/9M2PJU-POCO-F7
# License: GPL-3.0
# Author: 9M2PJU (9m2pju@gmail.com)
#
# Description:
#   Performs comprehensive device optimization and health maintenance on
#   POCO F7 (onyx / onyx_global) via ADB:
#   1. System status & health dashboard (battery temp, RAM, UFS storage)
#   2. UFS 4.1 storage TRIM (sm fstrim)
#   3. ART bytecode AOT speed-profile compilation
#   4. Stale cache cleanup (pm trim-caches)
#   5. Re-apply performance settings (animations, refresh rate, sound DSP)
#   6. Enforce background restrictions & standby buckets on heavy apps
#
# Usage:
#   bash optimize.sh          # Interactive mode with confirmation
#   bash optimize.sh --yes    # Non-interactive / unattended mode
#   bash optimize.sh --status # Show device dashboard only
# ==============================================================================

set -euo pipefail

# ANSI color codes
C_RESET="\033[0m"
C_BOLD="\033[1m"
C_DIM="\033[2m"
C_RED="\033[31m"
C_GREEN="\033[32m"
C_YELLOW="\033[33m"
C_BLUE="\033[34m"
C_CYAN="\033[36m"

AUTO_YES=false
STATUS_ONLY=false

for arg in "$@"; do
    case "$arg" in
        -y|--yes)
            AUTO_YES=true
            ;;
        -s|--status)
            STATUS_ONLY=true
            ;;
        -h|--help)
            echo "Usage: bash optimize.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -y, --yes     Run all optimization steps without prompting"
            echo "  -s, --status  Display device health dashboard only"
            echo "  -h, --help    Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown argument: $arg"
            echo "Use --help for usage information."
            exit 1
            ;;
    esac
done

# Verify ADB connection
check_adb() {
    if ! command -v adb >/dev/null 2>&1; then
        echo -e "${C_RED}Error: adb binary not found in PATH.${C_RESET}"
        exit 1
    fi

    local device_count
    device_count=$(adb devices </dev/null | grep -v "List of devices" | grep -c "device$" || true)

    if [[ "$device_count" -eq 0 ]]; then
        echo -e "${C_RED}Error: No authorized ADB device found.${C_RESET}"
        echo "Please connect your phone, enable USB Debugging, and accept the prompt."
        exit 1
    fi
}

adb_cmd() {
    adb shell "$@" </dev/null
}

show_dashboard() {
    echo -e "${C_CYAN}${C_BOLD}======================================================${C_RESET}"
    echo -e "${C_CYAN}${C_BOLD}          POCO F7 Device Health & Diagnostics         ${C_RESET}"
    echo -e "${C_CYAN}${C_BOLD}======================================================${C_RESET}"

    local market_name model rom_version android_ver patch_level
    market_name=$(adb_cmd "getprop ro.product.marketname" 2>/dev/null || echo "POCO F7")
    model=$(adb_cmd "getprop ro.product.model" 2>/dev/null || echo "Unknown")
    rom_version=$(adb_cmd "getprop ro.miui.ui.version.name" 2>/dev/null || echo "HyperOS")
    android_ver=$(adb_cmd "getprop ro.build.version.release" 2>/dev/null || echo "Unknown")
    patch_level=$(adb_cmd "getprop ro.build.version.security_patch" 2>/dev/null || echo "Unknown")

    echo -e "${C_BOLD}Device:${C_RESET}         ${C_GREEN}$market_name ($model)${C_RESET}"
    echo -e "${C_BOLD}OS / Android:${C_RESET}   ${C_GREEN}$rom_version / Android $android_ver (Patch: $patch_level)${C_RESET}"

    # Battery
    local bat_level bat_temp bat_volt
    bat_level=$(adb_cmd "dumpsys battery" 2>/dev/null | grep -E '^[ ]*level:' | head -n 1 | awk '{print $2}' || echo "N/A")
    bat_temp=$(adb_cmd "dumpsys battery" 2>/dev/null | grep -E '^[ ]*temperature:' | head -n 1 | awk '{print $2}' || echo "0")
    bat_volt=$(adb_cmd "dumpsys battery" 2>/dev/null | grep -E '^[ ]*voltage:' | head -n 1 | awk '{print $2}' || echo "0")
    local bat_temp_c
    bat_temp_c=$(awk "BEGIN {printf \"%.1f\", $bat_temp/10}" 2>/dev/null || echo "N/A")
    local bat_volt_v
    bat_volt_v=$(awk "BEGIN {printf \"%.2f\", $bat_volt/1000}" 2>/dev/null || echo "N/A")

    echo -e "${C_BOLD}Battery:${C_RESET}        ${C_GREEN}${bat_level}%${C_RESET} (${bat_temp_c} deg C, ${bat_volt_v}V)"

    # RAM
    local ram_line
    ram_line=$(adb_cmd "dumpsys meminfo" 2>/dev/null | grep "Total RAM:" || echo "")
    if [[ -n "$ram_line" ]]; then
        local free_ram_line
        free_ram_line=$(adb_cmd "dumpsys meminfo" 2>/dev/null | grep "Free RAM:" || echo "")
        echo -e "${C_BOLD}Memory (RAM):${C_RESET}   $ram_line"
        echo -e "                $free_ram_line"
    fi

    # Storage
    local storage_info
    storage_info=$(adb_cmd "df -h /data" 2>/dev/null | tail -n 1 || echo "")
    if [[ -n "$storage_info" ]]; then
        local total_storage used_storage free_storage use_pct
        total_storage=$(echo "$storage_info" | awk '{print $2}')
        used_storage=$(echo "$storage_info" | awk '{print $3}')
        free_storage=$(echo "$storage_info" | awk '{print $4}')
        use_pct=$(echo "$storage_info" | awk '{print $5}')
        echo -e "${C_BOLD}UFS Storage:${C_RESET}    ${C_GREEN}${free_storage} free${C_RESET} / ${total_storage} total (${use_pct} used, ${used_storage} occupied)"
    fi

    # Network / Wi-Fi
    local wifi_ssid wifi_speed
    wifi_ssid=$(adb_cmd "cmd wifi status" 2>/dev/null | grep -o 'Wifi is connected to "[^"]*"' | cut -d'"' -f2 || echo "")
    wifi_speed=$(adb_cmd "cmd wifi status" 2>/dev/null | grep -o 'Tx Link speed: [0-9]*Mbps' | head -n 1 || echo "")
    if [[ -n "$wifi_ssid" ]]; then
        echo -e "${C_BOLD}Wi-Fi Network:${C_RESET}  ${C_GREEN}$wifi_ssid${C_RESET} ($wifi_speed)"
    fi

    echo -e "${C_CYAN}${C_BOLD}======================================================${C_RESET}\n"
}

optimize_storage() {
    echo -e "${C_BLUE}[1/5] Running UFS 4.1 Storage TRIM (fstrim)...${C_RESET}"
    timeout 15 adb shell "sm fstrim" </dev/null >/dev/null 2>&1 || true
    echo -e "${C_GREEN}  Done: Storage filesystem trimmed.${C_RESET}"
}

optimize_art() {
    echo -e "${C_BLUE}[2/5] Running ART Bytecode Speed-Profile Compilation...${C_RESET}"
    echo -e "${C_DIM}  Compiling frequently used code paths into native bytecode...${C_RESET}"
    adb_cmd "cmd package compile -m speed-profile -a" >/dev/null 2>&1 || true
    echo -e "${C_GREEN}  Done: ART speed-profile compilation finished.${C_RESET}"
}

trim_caches() {
    echo -e "${C_BLUE}[3/5] Cleaning Stale App Caches...${C_RESET}"
    adb_cmd "pm trim-caches 1000G" >/dev/null 2>&1 || true
    echo -e "${C_GREEN}  Done: Temporary caches trimmed.${C_RESET}"
}

apply_settings() {
    echo -e "${C_BLUE}[4/5] Verifying & Enforcing System Performance Settings...${C_RESET}"

    # Animation scales (0.5x)
    adb_cmd "settings put global window_animation_scale 0.5"
    adb_cmd "settings put global transition_animation_scale 0.5"
    adb_cmd "settings put global animator_duration_scale 0.5"

    # Refresh rate & display
    adb_cmd "settings put system peak_refresh_rate 90"
    adb_cmd "settings put system screen_off_timeout 30000"
    adb_cmd "settings put global low_power_trigger_level 15"

    # Sound DSP wakeups off
    adb_cmd "settings put system sound_effects_enabled 0"
    adb_cmd "settings put system lockscreen_sounds_enabled 0"
    adb_cmd "settings put system dtmf_tone 0"
    adb_cmd "settings put global power_sounds_enabled 0"
    adb_cmd "settings put global charging_sounds_enabled 0"
    adb_cmd "settings put system charging_sounds_enabled 0"
    adb_cmd "settings put secure charging_sounds_enabled 0"

    # Wi-Fi & Radio optimizations
    adb_cmd "settings put global tether_offload_subsystem 1"
    adb_cmd "settings put global tether_offload_disabled 0"
    adb_cmd "settings put global wifi_scan_throttle_enabled 1"
    adb_cmd "settings put global network_avoid_bad_wifi 1"
    adb_cmd "settings put global wifi_scan_always_enabled 0"
    adb_cmd "settings put global ble_scan_always_enabled 0"
    adb_cmd "settings put global wifi_wakeup_enabled 0"
    adb_cmd "settings put global mobile_data_always_on 0"

    echo -e "${C_GREEN}  Done: Performance settings applied.${C_RESET}"
}

restrict_heavy_apps() {
    echo -e "${C_BLUE}[5/5] Enforcing Background Restrictions & Standby Buckets...${C_RESET}"

    local restricted_pkgs=(
        "com.facebook.katana"
        "com.lemon.lvoverseas"
        "com.tranzmate"
        "com.sagadsg.user.mady501857"
        "my.com.tngdigital.ewallet"
        "com.shopeepay.my"
        "com.shopee.my"
        "com.ss.android.ugc.trill"
        "com.alibaba.aliexpresshd"
        "com.taobao.taobao"
        "com.xunmeng.pinduoduo"
        "tiktok.video.downloader.nowatermark.tiktokdownload.snaptik"
        "org.zwanoo.android.speedtest"
        "com.intsig.camscanner"
        "com.thecarousell.Carousell"
        "com.agoda.mobile.consumer"
        "com.airbnb.android"
        "com.shell.sitibv.shellgoplusindia"
        "my.com.petron.app"
    )

    local count=0
    for pkg in "${restricted_pkgs[@]}"; do
        # Check if installed
        if adb_cmd "pm path $pkg" >/dev/null 2>&1; then
            adb_cmd "cmd appops set $pkg RUN_IN_BACKGROUND deny" 2>/dev/null || true
            adb_cmd "cmd appops set $pkg RUN_ANY_IN_BACKGROUND deny" 2>/dev/null || true
            adb_cmd "am set-standby-bucket $pkg restricted" 2>/dev/null || true
            adb_cmd "am force-stop $pkg" 2>/dev/null || true
            count=$((count + 1))
        fi
    done

    echo -e "${C_GREEN}  Done: Enforced background restrictions across $count installed apps.${C_RESET}"
}

# Main execution
check_adb
show_dashboard

if [[ "$STATUS_ONLY" == true ]]; then
    exit 0
fi

if [[ "$AUTO_YES" != true ]]; then
    echo -e "${C_BOLD}Do you want to run the full optimization suite on this device?${C_RESET}"
    echo "  1) Yes - run all optimizations"
    echo "  2) No - exit"
    echo ""
    read -r -p "Select option [1-2] (default: 1): " choice </dev/tty || choice="1"
    choice="${choice:-1}"

    if [[ "$choice" != "1" && "$choice" != "y" && "$choice" != "yes" ]]; then
        echo "Optimization aborted."
        exit 0
    fi
    echo ""
fi

echo -e "${C_CYAN}${C_BOLD}Starting POCO F7 optimization suite...${C_RESET}\n"

optimize_storage
optimize_art
trim_caches
apply_settings
restrict_heavy_apps

echo -e "\n${C_GREEN}${C_BOLD}======================================================${C_RESET}"
echo -e "${C_GREEN}${C_BOLD}   All optimizations completed successfully!          ${C_RESET}"
echo -e "${C_GREEN}${C_BOLD}======================================================${C_RESET}\n"

# Final summary dashboard
show_dashboard
