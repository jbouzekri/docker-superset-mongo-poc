#!/bin/bash

# Wait for Superset to be ready
sleep 30

echo "Creating the admin user..."
superset fab create-admin \
         --username reckoning_admin \
         --firstname Ben \
         --lastname Eberle \
         --email eberlebe@umich.edu \
         --password test || { echo "Failed to create admin user"; exit 1; }

echo "Upgrading the database..."
superset db upgrade || { echo "Database upgrade failed"; exit 1; }

echo "Initializing Superset..."
superset init || { echo "Superset initialization failed"; exit 1; }

echo "Starting the Superset server..."
superset run -p 8080 --with-threads --reload