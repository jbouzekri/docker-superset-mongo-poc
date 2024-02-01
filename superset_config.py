import secrets

# ---------------------------------------------------------
# Superset specific config
# ---------------------------------------------------------

# Set row limit for improved performance
ROW_LIMIT = 5000

# Set number of workers
SUPERSET_WORKERS = 4

# Set Secret Key
SECRET_KEY = secrets.token_urlsafe(16)

# 
SESSION_COOKIE_SAMESITE = None  # One of [None, 'Lax', 'Strict']

# Flask-WTF flag for CSRF
WTF_CSRF_ENABLED = False

# Branding
LOGO_TARGET_PATH = 'https://sites.lsa.umich.edu/dcc-project/the-reckoning-project/'
APP_ICON = 'TheReckoningProject_logo.png'
FAVICONS = 'TheReckoningProject_logo.png'
APP_NAME = 'The Reckoing Project'
WELCOME_MESSAGE = 'Welcome!'