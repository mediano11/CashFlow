#!/bin/bash

echo "Check if backup file path is provided"
if [ -z "$1" ]; then
    echo "Error: No backup file path provided."
    echo "Usage: $0 <backup_file_path>"
    exit 1
fi

backup_file_path=$1

# Check if the backup file exists
if [ ! -f "$backup_file_path" ]; then
    echo "Error: Backup file not found at path: $backup_file_path"
    exit 1
fi

echo "Searching for db container..."

container_name=postgres_db

container_id=$(docker ps -qf "name=$container_name")

if [ -z "$container_id" ]; then
    echo "Error: No container found with the name: $container_name"
    exit 1
fi

echo "Restoring..."

docker exec -i $container_id pg_restore -U postgres -d cash_money --clean < "$backup_file_path"

echo "Done!"
