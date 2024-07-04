#!/bin/bash

time1=$(date "+%Y-%m-%d %H:%M")
echo "anomalous_queue_construction start: $time1"

python anomalous_queue_construction.py

time2=$(date "+%Y-%m-%d %H:%M")
echo "anomalous_queue_construction ends: $time2"

timestamp1=$(date -d "$time1" +%s)
timestamp2=$(date -d "$time2" +%s)
diff=$((timestamp2 - timestamp1))
diff_minutes=$((diff / 60))

echo "anomalous_queue_construction time difference: $diff_minutes mins"
echo "============================================"
