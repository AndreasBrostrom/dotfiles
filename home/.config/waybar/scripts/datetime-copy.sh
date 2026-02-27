#!/bin/bash
# Show rofi menu with date formats and copy selected to clipboard

UNIX=$(date +%s)
ISO=$(date +%Y-%m-%d)
ISO_FULL=$(date +%Y-%m-%dT%H:%M:%S)
HUMAN=$(date "+%A, %d %B %Y")
WARHAMMER="1 $(date | date2isc)"
TIME=$(date +%H:%M:%S)

CHOICE=$(printf "%s\n%s\n%s\n%s\n%s\n%s" \
    "$ISO" \
    "$ISO_FULL" \
    "$HUMAN" \
    "$TIME" \
    "$UNIX" \
    "$WARHAMMER" \
    | rofi -dmenu -p "Copy date:")

[ -n "$CHOICE" ] && echo -n "$CHOICE" | wl-copy
