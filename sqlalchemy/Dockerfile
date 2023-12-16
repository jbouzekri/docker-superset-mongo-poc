FROM --platform=linux/amd64 ubuntu:16.04

RUN apt-get update && apt-get install -y \
    wget \
    libgssapi-krb5-2 \
    rsyslog \
    openssl \
    libssl-dev \
    python3 \
    python3-dev \
    build-essential \
    libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://bootstrap.pypa.io/pip/3.5/get-pip.py \
    && python3 get-pip.py \
    && rm get-pip.py

RUN pip install \
    sqlalchemy \
    mysqlclient \
    sqlalchemy-mongobi

ENV LIBMYSQL_ENABLE_CLEARTEXT_PLUGIN=1

WORKDIR /sqlalchemy
