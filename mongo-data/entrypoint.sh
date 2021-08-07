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

wget https://github.com/ozlerhakan/mongodb-json-files/raw/master/datasets/tweets.zip
unzip tweets.zip
mongorestore --drop --uri ${MONGO_DB_URI} --nsInclude=samples.tweets dump/twitter/tweets.bson
rm -rf dump tweets.zip
mongo ${MONGO_DB_URI} --eval 'db.tweets.updateMany({}, [{ "$set": { "created_at": { "$toDate": "$created_at" } }}]);'