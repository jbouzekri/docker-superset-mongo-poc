#!/usr/bin/env /bin/bash

INIT_DONE_FILE=/init.done

superset fab create-admin \
            --username $ADMIN_USERNAME \
            --firstname Superset \
            --lastname Admin \
            --email $ADMIN_EMAIL \
            --password $ADMIN_PASSWORD

superset db upgrade

superset init

gunicorn_reload=''
if [[ "$ENABLE_DEV_MODE" == "1" ]]; then
    gunicorn_reload='--reload'
fi

if ! grep -q '# SSM_MONBI' /app/superset/sql_lab.py; then
  sed -i -z 's/        # Commit the connection so CTA queries will create the table.\n        conn.commit()/        # SSM_MONBI\n        # Commit the connection so CTA queries will create the table.\n        # conn.commit()/g' /app/superset/sql_lab.py
fi

gunicorn \
    --bind  "0.0.0.0:${SUPERSET_PORT}" \
    --access-logfile '-' \
    --error-logfile '-' \
    --workers 1 \
    --worker-class gthread \
    --threads 20 \
    --timeout 60 \
    --limit-request-line 0 \
    --limit-request-field_size 0 \
    $gunicorn_reload \
    "${FLASK_APP}"