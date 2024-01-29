#!/bin/bash

# Create an admin user (you will be prompted to set a username, first and last name before setting a password)
superset fab create-admin \
              --username admin \
              --firstname Ben \
              --lastname Eberle \
              --email eberlebe@umich.edu \
              --password test

# Initialize the database
superset db upgrade

# Create default roles and permissions
superset init

# To start a development web server, use the -p option to bind to another port
superset run -p 8088 --with-threads --reload --debugger
