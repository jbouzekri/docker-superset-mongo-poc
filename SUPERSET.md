# Superset step by step

Go to [http://localhost:8088/](http://localhost:8088/) and connect using admin credentials `admin` / `admin`

Create a new Database with the following configuration :

* *BASIC / DISPLAY NAME* : `MongoBI`
* *BASIC / SQLALCHEMY URI* : `mongobi://root?source=admin:root@poc_ssm_mongo_bi:3307/samples`

![](./doc/01_database.png)

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

![](./doc/02_database.png)

Create a new dataset for the table `companies` in the `samples` database of the previously created `MongoBI` superset database.

* *DATASOURCE* : `MongoBI`
* *SCHEMA* : `samples`
* *TABLE* : `companies`

![](./doc/03_dataset.png)

Create another new dataset for the table `companies_office` in the `samples` database of the previously created `MongoBI` superset database.

* *DATASOURCE* : `MongoBI`
* *SCHEMA* : `samples`
* *TABLE* : `companies_offices`

![](./doc/04_dataset.png)

Next we can create our first chart using the `companies` dataset. This is :

* A Bar Chart
* With the metric `count(*)`
* 2 filters
    * `count(*) > 100`
    * `acquisition.acquired_year IS NOT NULL`
* 1 serie (to group by) `acquisition.acquired_year`

![](./doc/05_chart.png)

The bar chart is customized to `sort bars`

![](./doc/06_chart.png)

This is the first proof of concept of our POC. We are able to create charts using a collection in a mongodb database.

Now let's start to create a chart based on a query built in the sql lab query editor. And to add a little bit more of a complexity, it will be a query with a join condition.

Open the `SQL Lab / SQL Editor` and type the following query then `RUN` :

```sql
SELECT companies._id, companies.name, companies_offices.`offices.city`, companies_offices.`offices.country_code`  
FROM companies 
LEFT JOIN companies_offices ON companies._id = companies_offices._id;
```

![](./doc/07_sqllab.png)

Look at the table extract where we have office in multiple countries.

Then click on `EXPLORE` and save this query as a new virtual table / virtual dataset named `test`

![](./doc/08_virtual_table.png)

Create a new chart using this query :

* A table in query mode `RAW RECORDS`
* With all the columns selected
* and one filter `offices.country_code = 'USA`

![](./doc/09_virtual_table.png)

The table is filtered to only show companies and their offices located in USA. This demonstrate that we can create virtual table in superset and manipulate them in the dashboard and chart editors.
