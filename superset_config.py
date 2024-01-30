import secrets

# ---------------------------------------------------------
# Superset specific config
# ---------------------------------------------------------
ROW_LIMIT = 5000

SUPERSET_WORKERS = 4 

SERVER_HOST = '0.0.0.0'
SUPERSET_WEBSERVER_PORT = 8080

SECRET_KEY = secrets.token_urlsafe(16)

# Flask-WTF flag for CSRF
WTF_CSRF_ENABLED = True