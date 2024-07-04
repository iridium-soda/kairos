#!/bin/bash
# To clean and reset the experiment env
# Check if artifact directory exists before attempting to delete its contents

echo "============================================"
time1=$(date "+%Y-%m-%d %H:%M")
echo "Clean start: $time1"

if [ -d "./artifact" ]; then
    rm -rf ./artifact/*
else
    echo "Directory ./artifact does not exist."
fi

# Delete database in PostgreSQL
DATABASE="tc_cadet_dataset_db"

psql -U root -d $DATABASE -f ./scripts/delete_database.sql
if [ $? -eq 0 ]; then
    echo "Database $DATABASE successfully reset."
else
    echo "Failed to reset database $DATABASE."
fi

time2=$(date "+%Y-%m-%d %H:%M")
echo "Clean ends: $time2"

timestamp1=$(date -d "$time1" +%s)
timestamp2=$(date -d "$time2" +%s)
diff=$((timestamp2 - timestamp1))
diff_minutes=$((diff / 60))
echo "Cleanup time difference: $diff_minutes mins"
echo "============================================"
