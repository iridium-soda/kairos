#! /bin/bash
# To clean and reset the experiment env
# Check if artifact directory exists before attempting to delete its contents
if [ -d "./artifact" ]; then
    rm -rf ./artifact/*
else
    echo "Directory ./artifact does not exist."
fi

# Delete database in postgresql
DATABASE="tc_cadet_dataset_db"

psql  -U root -d postgres -f ./scripts/delete_database.sql
if [ $? -eq 0 ]; then
    echo "Database $DATABASE successfully reset."
else
    echo "Failed to reset database $DATABASE."
fi
