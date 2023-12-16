#!/usr/bin/env /bin/bash

if [[ -z "${MONGO_DB_URI}" ]] ; then
    echo "missing MONGO_DB_URI environment variable"
    exit 1
fi

if [[] $(mongo ${MONGO_DB_URI} --eval 'db.getMongo().getDBNames().indexOf("reckoning")' --quiet) -gt 0 ]] ; then
    echo "reckoning database exist. Exiting ..."
    exit 0
fi

mongoimport --drop -c reckoning --uri ${MONGO_DB_URI} master_df.json --jsonArray
rm master_df.json