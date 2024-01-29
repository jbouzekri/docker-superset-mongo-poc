#!/bin/bash

# Initialize the database
superset db upgrade

# Create an admin user (you will be prompted to set a username, first and last name before setting a password)
superset fab create-admin

# Create default roles and permissions
superset init

# To start a development web server, use the -p option to bind to another port
superset run -p 8080 --with-threads --reload --debugger
