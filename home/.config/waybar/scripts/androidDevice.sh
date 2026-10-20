#!/bin/bash
# Waybar custom module for Android device connection monitoring
# Checks if a specific Android device is connected via ADB

_symbol="" # Font Awesome android
_device="3A271JEHN06791"

# Start ADB server if not running
adb start-server >/dev/null 2>&1

while true; do
    if [[ $(pgrep adb) ]]; then
        # ADB server is running, check for device
        if adb devices -l 2>/dev/null | grep -q "$_device"; then
            # Device is connected
            [[ -n "$_model" ]] || _model="$(adb -s "$_device" shell getprop ro.product.model 2>/dev/null | tr -d '\r')"
            tooltip="<span color='#7aa6c4'><b>Android</b></span>\\n<span color='#8f8a80'>Device</span>  ${_model:-$_device}\\n<span color='#8f8a80'>Serial</span>  $_device\\n<span color='#8f8a80'><small>click for scrcpy, wake, reboot</small></span>"
            echo "{\"text\": \"$_symbol\", \"tooltip\": \"$tooltip\", \"class\": \"connected\"}"
        else
            # ADB running but device not connected
            _model=""
            echo "{\"text\": \"\", \"tooltip\": \"No Android device\", \"class\": \"disconnected\"}"
        fi
    else
        # ADB server not running
        echo "{\"text\": \"\", \"tooltip\": \"ADB server not running\", \"class\": \"no-server\"}"
    fi

    sleep 5
done
