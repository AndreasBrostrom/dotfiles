#!/bin/bash
# Waybar custom module for cpu, memory, disk, temperature and backlight.
# Replaces the built-in modules because those only support plain-text
# (or, for cpu, fixed) tooltips; this prints themed Pango markup instead.
# Usage: sysinfo.sh cpu|memory|disk|temperature|backlight

# Grimdark palette (see style.css)
_c_title="#7aa6c4"
_c_dim="#8f8a80"
_c_hot="#b8625a"
_c_busy="#bfa36a"
_c_text="#d8d2c4"

_grid_cols=4

_critical=80

title() { printf "<span color='%s'><b>%s</b></span>" "$_c_title" "$1"; }
row()   { printf "\n<span color='%s'>%s</span>  %s" "$_c_dim" "$1" "$2"; }
hint()  { printf "\n<span color='%s'><small>%s</small></span>" "$_c_dim" "$1"; }
human() { numfmt --to=iec-i --suffix=B --format="%.1f" "$1"; }

output() {
    jq -cn --arg text "$1" --arg tooltip "$2" --arg class "${3:-}" \
        '{text: $text, tooltip: $tooltip} + (if $class == "" then {} else {class: $class} end)'
}

# Prints the "idle total" jiffies of every line in /proc/stat starting with cpu
cpu_times() {
    awk '/^cpu/ {print $5 + $6, $2 + $3 + $4 + $5 + $6 + $7 + $8 + $9}' /proc/stat
}

# Usage colour: idle dim, normal bone, busy brass, maxed red
load_color() {
    if (( $1 >= 90 )); then echo "$_c_hot"
    elif (( $1 >= 60 )); then echo "$_c_busy"
    elif (( $1 >= 10 )); then echo "$_c_text"
    else echo "$_c_dim"
    fi
}

cpu() {
    local before after usage=() i idle total
    mapfile -t before < <(cpu_times)
    sleep 0.5
    mapfile -t after < <(cpu_times)
    for i in "${!after[@]}"; do
        read -r idle1 total1 <<< "${before[$i]}"
        read -r idle2 total2 <<< "${after[$i]}"
        total=$((total2 - total1)); idle=$((idle2 - idle1))
        usage[i]=$(( total > 0 ? 100 * (total - idle) / total : 0 ))
    done

    local load avg max cores grid="" col=0 pct
    read -r l1 l5 l15 _ < /proc/loadavg
    load="$l1  $l5  $l15"
    avg=$(awk -F: '/^cpu MHz/ {s += $2; n++} END {if (n) printf "%.1f", s / n / 1000}' /proc/cpuinfo)
    max=$(awk '{printf "%.1f", $1 / 1000000}' /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq 2>/dev/null)
    cores=$(( ${#usage[@]} - 1 ))

    # Per-core grid: steel core name, bold percentage coloured by load, _grid_cols cores per row
    # (index 0 is the total line)
    for (( i = 1; i <= cores; i++ )); do
        pct=${usage[i]}
        grid+=$(printf "<span color='%s'><b>C%-2d</b></span> <span color='%s'><b>%3d%%</b></span>" \
            "$_c_title" $((i - 1)) "$(load_color "$pct")" "$pct")
        if (( ++col == _grid_cols )); then grid+=$'\n'; col=0; else grid+="    "; fi
    done
    grid="${grid%$'\n'}"

    output "${usage[0]}% " \
        "$(title CPU)$(row Usage "${usage[0]}%")$(row Load "$load")$(row Clock "${avg} GHz avg · ${max} GHz max")$(row Cores "$cores")
<tt>$grid</tt>"
}

memory() {
    local total avail swap_total swap_free used pct
    total=$(awk '/^MemTotal/ {print $2 * 1024}' /proc/meminfo)
    avail=$(awk '/^MemAvailable/ {print $2 * 1024}' /proc/meminfo)
    swap_total=$(awk '/^SwapTotal/ {print $2 * 1024}' /proc/meminfo)
    swap_free=$(awk '/^SwapFree/ {print $2 * 1024}' /proc/meminfo)
    used=$((total - avail))
    pct=$((100 * used / total))

    output "$pct% " \
        "$(title Memory)$(row Used "$(human $used) / $(human $total)  ($pct%)")$(row Free "$(human $avail)")$(row Swap "$(human $((swap_total - swap_free))) / $(human $swap_total)")"
}

disk() {
    local size used avail pct
    read -r size used avail pct < <(df -B1 --output=size,used,avail,pcent / | tail -1)
    pct="${pct%\%}"

    output "$pct% ⛁" \
        "$(title Disk) <span color='$_c_dim'>/</span>$(row Used "$(human $used) / $(human $size)  ($pct%)")$(row Free "$(human $avail)")"
}

# Prints the temperature of the first hwmon sensor with the given name, in °C
hwmon_temp() {
    local dir
    for dir in /sys/class/hwmon/hwmon*; do
        if [[ "$(cat "$dir/name" 2>/dev/null)" == "$1" && -r "$dir/temp1_input" ]]; then
            echo $(( $(cat "$dir/temp1_input") / 1000 ))
            return
        fi
    done
}

temperature() {
    local temp icon class="" tooltip sensor value
    # Same source as waybar's built-in temperature module
    temp=$(( $(cat /sys/class/thermal/thermal_zone0/temp) / 1000 ))
    if (( temp >= _critical )); then icon=""; class="critical"
    elif (( temp >= 60 )); then icon=""
    else icon=""
    fi

    tooltip="$(title Temperature)"
    for sensor in "CPU:k10temp" "CPU:coretemp" "GPU:amdgpu" "NVMe:nvme" "System:acpitz"; do
        value=$(hwmon_temp "${sensor#*:}")
        [[ -n "$value" ]] && tooltip+="$(row "${sensor%%:*}" "$value°C")"
    done
    tooltip+="$(hint "critical at $_critical°C")"

    output "$temp°C $icon" "$tooltip" "$class"
}

backlight() {
    local icons=("" "" "" "" "" "" "" "" "") device current max pct
    IFS=, read -r device _ current _ max < <(brightnessctl -m info)
    pct=$(( (100 * current + max / 2) / max ))

    output "$pct% ${icons[$(( pct * ${#icons[@]} / 101 ))]}" \
        "$(title Brightness)$(row Screen "$pct%")$(row Device "$device")$(hint "scroll to adjust")"
}

case "$1" in
    cpu|memory|disk|temperature|backlight) "$1" ;;
    *) echo "Usage: $0 cpu|memory|disk|temperature|backlight" >&2; exit 1 ;;
esac
