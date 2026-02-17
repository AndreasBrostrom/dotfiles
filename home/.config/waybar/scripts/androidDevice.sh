#!/bin/bash
# Waybar custom module for Android device connection monitoring
# Checks if a specific Android device is connected via ADB

_symbol="✆"
_device="3A271JEHN06791"

# Start ADB server if not running
adb start-server >/dev/null 2>&1

while true; do
    if [[ $(pgrep adb) ]]; then
        # ADB server is running, check for device
        if adb devices -l 2>/dev/null | grep -q "$_device"; then
            # Device is connected
            echo "{\"text\": \"$_symbol\", \"tooltip\": \"Android device connected\", \"class\": \"connected\"}"
        else
            # ADB running but device not connected
            echo "{\"text\": \"\", \"tooltip\": \"No Android device\", \"class\": \"disconnected\"}"
        fi
    else
        # ADB server not running
        echo "{\"text\": \"\", \"tooltip\": \"ADB server not running\", \"class\": \"no-server\"}"
    fi

    sleep 5
done
