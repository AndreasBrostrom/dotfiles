#!/bin/bash
# Output both Unix timestamp and Warhammer GST as JSON

UNIX=$(date +%s)
WARHAMMER="M$(($(date +%Y) + 40000)).$(date +%j)"

echo "{\"text\":\"$UNIX\", \"alt\":\"$WARHAMMER\", \"tooltip\":\"Click to toggle\"}"
