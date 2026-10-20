#!/bin/bash
# Output both Unix timestamp and Warhammer GST as JSON
# Runs continuously and wakes on each full second, so it ticks together with waybar's clock

T="<span color='#7aa6c4'><b>Time</b></span>"
D="<span color='#8f8a80'>"

while true; do
    UNIX=$(date +%s)
    WARHAMMER="1 $(date -d "@$UNIX" | date2isc)"
    TOOLTIP="$T\\n${D}Unix</span>  $UNIX\\n${D}Imperial</span>  $WARHAMMER\\n${D}<small>click to toggle · right-click to copy a format</small></span>"

    echo "{\"text\":\"$UNIX\", \"alt\":\"$WARHAMMER\", \"tooltip\":\"$TOOLTIP\"}"

    # Sleep until the next second boundary
    NS=$(date +%N)
    sleep "0.$(printf '%09d' $((1000000000 - 10#$NS)))"
done
