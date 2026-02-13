#!/bin/bash
# Output both Unix timestamp and Warhammer GST as JSON

UNIX=$(date +%s)
WARHAMMER="1 $(date | date2isc)"

echo "{\"text\":\"$UNIX\", \"alt\":\"$WARHAMMER\", \"tooltip\":\"Click to toggle\"}"
