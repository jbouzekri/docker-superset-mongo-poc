# Superset Mongo via Mongo BI connector

This is a simple [docker-compose](./docker-compose.yaml) project to demonstrate how to query a [MongoDB](https://www.mongodb.com/try/download/community) database with [Apache Superset](https://superset.apache.org/) through the [MongoDB BI Connector](https://docs.mongodb.com/bi-connector/v2.14/).

I would like to thanks [@smarzola](https://github.com/smarzola/) for his [sqlalchemy-mongobi](https://github.com/smarzola/sqlalchemy-mongobi) python package which adds a dialect for sqlalchemy disabling transactions not supported with the BI connector.

## Description

This docker compose project is made up of these containers :

* `poc_ssm_mongo` : a mongo 5 single instance
* `poc_ssm_mongo_express` : a mongo express UI to browse the data in the instance at [http://localhost:8081/](http://localhost:8081/)
* `poc_ssm_mongo_bi` : a mongo bi connector connected to the mongo instance
* `poc_ssm_mongo_data` : a container loading a sample dataset in the mongo instance
* `poc_ssm_mysql_client` : a container with a mysql cli client to demonstrate connection through the mongo bi connector
* `poc_ssm_sqlalchemy` : a container with a simple sqlalchemy script to demonstrate connection through the mongo bi connector
* `poc_ssm_superset` : a container with a superset instance to demonstrate connection through the mongo bi connector

## Usage

Starts the project

```
docker-compose up
```

Wait for everything to be ready and for the `poc_ssm_mongo_data` to exit with a 0 status code.

*Note : look at the logs of the superset instance before connecting to wait for all the init scripts in the entrypoint to finish before the gunicorn web server is started*

Then you can try the different connection mode.

### 1. mysql cli client

```
$ docker-compose exec poc_ssm_mysql_client bash

# mysql -h poc_ssm_mongo_bi -P 3307 -u 'root?source=admin' --default-auth=mongosql_auth -proot
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 457
Server version: 5.7.12 mongosqld v2.14.3 mongosqld v2.14.3

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| INFORMATION_SCHEMA |
| mysql              |
| samples            |
+--------------------+
3 rows in set (0.00 sec)

mysql> use samples;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed

mysql> show tables;
+---------------------------------------+
| Tables_in_samples                     |
+---------------------------------------+
| companies                             |
| companies_acquisitions                |
| companies_competitions                |
| companies_external_links              |
| companies_funding_rounds              |
| companies_funding_rounds_investments  |
| companies_image_available_sizes       |
| companies_investments                 |
| companies_milestones                  |
| companies_offices                     |
| companies_partners                    |
| companies_products                    |
| companies_providerships               |
| companies_relationships               |
| companies_screenshots                 |
| companies_screenshots_available_sizes |
| companies_video_embeds                |
+---------------------------------------+
17 rows in set (0.00 sec)

mysql> select * from companies limit 1\G
*************************** 1. row ***************************
_id: 52cdef7c4bab8bd675297d8b
name: AdventNet
1 row in set (0.00 sec)

mysql> 
```

### 2. sqlalchemy script

```
$ docker-compose exec poc_ssm_sqlalchemy bash

# python3 query.py 
/usr/local/lib/python3.5/dist-packages/sqlalchemy/engine/default.py:410: SAWarning: Exception attempting to detect unicode returns: ProgrammingError('(MySQLdb._exceptions.ProgrammingError) (1064, "parse sql \'SELECT CAST(\'test collated returns\' AS CHAR CHARACTER SET utf8mb4) COLLATE utf8mb4_bin AS anon_1\' error: unexpected CHARACTER at position 55 near CHARACTER")',)
  "detect unicode returns: %r" % de
------------
[
  {
    "name": "AdventNet",
    "_id": "52cdef7c4bab8bd675297d8b"
  },
  {
    "name": "Wetpaint",
    "_id": "52cdef7c4bab8bd675297d8a"
  }
]
```

### 3. Superset

This example has a few screenshots and the page is a bit long so it has been moved to a [dedicated documentation](./SUPERSET.md)

## Important

You can look at the different Dockerfile and entrypoint.sh scripts to see the details. However there are a few things I did in this POC and I want to point out. 

1. Mongo BI connector :

    1. As the database is in auth mode, the bi connector needs to be too (`--auth`) and needs to be secured with TLS `--sslMode=allowSSL` and `--sslPEMKeyFile=/path/to/an/autosigned/pem/cert/and/key`

    2. schema refresh has been enabled and is automatic but you can [build your own schema](https://docs.mongodb.com/bi-connector/v2.14/schema-configuration/)

2. Superset : 

    1. in file `/app/superset/sql_lab.py` around line `432`, there is a `conn.commit()` instruction that needs to be commented in order to be able to use the sql lab.

    2. as the mysqlclient sends the password as cleartext (over tls), you need to add the `LIBMYSQL_ENABLE_CLEARTEXT_PLUGIN=1` environment variable