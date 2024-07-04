#!/bin/bash

time1=$(date "+%Y-%m-%d %H:%M")
echo "embedding start: $time1"

python embedding.py

time2=$(date "+%Y-%m-%d %H:%M")
echo "embedding ends: $time2"

timestamp1=$(date -d "$time1" +%s)
timestamp2=$(date -d "$time2" +%s)
diff=$((timestamp2 - timestamp1))
diff_minutes=$((diff / 60))

echo "embedding time difference: $diff_minutes mins"
echo "============================================"
