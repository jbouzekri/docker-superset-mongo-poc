import sqlalchemy
import os
import json

mongobi_host = os.getenv('MONGO_BI_HOST')
mongobi_username = os.getenv('MONGO_BI_USERNAME')
mongobi_password = os.getenv('MONGO_BI_PASSWORD')
mongobi_port = os.getenv('MONGO_BI_PORT')
mongobi_db = os.getenv('MONGO_BI_DATABASE')

mongobi_uri = "mongobi://{}:{}@{}:{}/{}".format(mongobi_username, mongobi_password, mongobi_host, mongobi_port, mongobi_db)

engine = sqlalchemy.create_engine(
    mongobi_uri,
    connect_args={
        "ssl": {
            "mode": "PREFERRED"
        },
    },
)

with engine.connect() as conn:
    result = conn.execute("select _id, name from companies limit 2")
    print('------------')
    print(json.dumps([dict(zip(row.keys(), row)) for row in result], indent=2))
    