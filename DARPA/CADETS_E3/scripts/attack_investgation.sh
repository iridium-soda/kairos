#!/bin/bash

time1=$(date "+%Y-%m-%d %H:%M")
echo "attack_investigation start: $time1"

python attack_investigation.py

time2=$(date "+%Y-%m-%d %H:%M")
echo "attack_investigation ends: $time2"

timestamp1=$(date -d "$time1" +%s)
timestamp2=$(date -d "$time2" +%s)
diff=$((timestamp2 - timestamp1))
diff_minutes=$((diff / 60))

echo "attack_investigation time difference: $diff_minutes mins"
echo "============================================"
