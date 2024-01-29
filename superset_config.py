import secrets

# ---------------------------------------------------------
# Superset specific config
# ---------------------------------------------------------
ROW_LIMIT = 5000

SUPERSET_WORKERS = 4 

SUPERSET_WEBSERVER_PORT = 8088

SECRET_KEY = secrets.token_urlsafe(16)

# The SQLAlchemy connection string to your database backend
# This connection defines the path to the database that stores your
# superset metadata (slices, connections, ...)
SQLALCHEMY_DATABASE_URI = 'awsathena+rest://@athena.us-west-2.amazonaws.com:443/s3://reckoning-s3-bucket/query_results/?s3_staging_dir=s3://reckoning-s3-bucket/query_results/&schema_name=data'

# Flask-WTF flag for CSRF
WTF_CSRF_ENABLED = True