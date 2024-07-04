#!/bin/bash

time1=$(date "+%Y-%m-%d %H:%M")
echo "create_database start: $time1"

python create_database.py

time2=$(date "+%Y-%m-%d %H:%M")
echo "create_database ends: $time2"

timestamp1=$(date -d "$time1" +%s)
timestamp2=$(date -d "$time2" +%s)
diff=$((timestamp2 - timestamp1))
diff_minutes=$((diff / 60))

echo "create_database time difference: $diff_minutes mins"
echo "============================================"
