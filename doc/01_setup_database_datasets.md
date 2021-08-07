# Superset - 01 Setup the database and datasets

Go to [http://localhost:8088/](http://localhost:8088/) and connect using admin credentials `admin` / `admin`

Create a new Database with the following configuration :

* *BASIC / DISPLAY NAME* : `MongoBI`
* *BASIC / SQLALCHEMY URI* : `mongobi://root?source=admin:root@poc_ssm_mongo_bi:3307/samples`

![](./img/01_database.png)

* *ADVANCED / OTHER / EXTRA* :

```json
{
  "metadata_params": {},
  "engine_params": {
    "connect_args": {
        "ssl": {
            "mode": "PREFERRED"
        }
    }
  },
  "metadata_cache_timeout": {},
  "schemas_allowed_for_csv_upload": [] 
}
```

![](./img/02_database.png)

Create a new dataset for the table `companies` in the `samples` database of the previously created `MongoBI` superset database.

* *DATASOURCE* : `MongoBI`
* *SCHEMA* : `samples`
* *TABLE* : `companies`

![](./img/03_dataset.png)

Create another new dataset for the table `companies_office` in the `samples` database of the previously created `MongoBI` superset database.

* *DATASOURCE* : `MongoBI`
* *SCHEMA* : `samples`
* *TABLE* : `companies_offices`

![](./img/04_dataset.png)

Create another new dataset for the table `tweets` in the `samples` database of the previously created `MongoBI` superset database.

* *DATASOURCE* : `MongoBI`
* *SCHEMA* : `samples`
* *TABLE* : `tweets`

![](./img/05_dataset.png)

**Next we are going to create a [simple bar chart]()