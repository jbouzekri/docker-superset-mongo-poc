FROM apache/superset:1.2.0

USER root

RUN apt-get update && apt-get install -y \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN pip install mysqlclient \
    && pip install sqlalchemy-mongobi

COPY entrypoint.sh /
RUN chmod a+x /entrypoint.sh

USER superset

ENV LIBMYSQL_ENABLE_CLEARTEXT_PLUGIN=1

ENTRYPOINT ["/entrypoint.sh"]