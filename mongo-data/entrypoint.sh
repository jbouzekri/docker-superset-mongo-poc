#!/usr/bin/env /bin/bash

if [[ -z "${MONGO_DB_URI}" ]] ; then
    echo "missing MONGO_DB_URI environment variable"
    exit 1
fi

if [[] $(mongo ${MONGO_DB_URI} --eval 'db.getMongo().getDBNames().indexOf("samples")' --quiet) -gt 0 ]] ; then
    echo "samples database exist. Exiting ..."
    exit 0
fi

wget https://raw.githubusercontent.com/ozlerhakan/mongodb-json-files/master/datasets/companies.json
mongoimport --drop -c companies --uri ${MONGO_DB_URI} companies.json
rm companies.json
