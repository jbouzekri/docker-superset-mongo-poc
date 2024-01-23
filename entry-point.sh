#!/bin/bash

# Wait for the Superset service to start
sleep 10

# configure admin user
sudo docker exec -it superset superset fab create-admin \
              --username reckoning_admin \
              --firstname Ben \
              --lastname Eberle \
              --email eberlebe@umich.edu \
              --password ${SUPERSET_PWD}

# Initialize the database
sudo superset db upgrade

# Create default roles and permissions
sudo superset init

# Start the Superset server
sudo docker run -d -p 8080:8088 \
             -e "SUPERSET_SECRET_KEY=$(openssl rand -base64 42)" \
             -e "TALISMAN_ENABLED=False" \
             --name superset apache/superset \
             --with-threads --reload --debugger