FROM apache/superset

USER root

RUN pip install pyathena

COPY /logo /app
COPY superset_config.py /app/superset_config.py
COPY superset-init.sh /app/superset-init.sh
RUN chmod +x /app/superset-init.sh

USER superset
