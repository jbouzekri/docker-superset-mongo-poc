FROM --platform=linux/amd64 ubuntu:20.04

RUN apt-get update && apt-get install -y \
  wget \
  libgssapi-krb5-2 \
  rsyslog \
  openssl \
  libssl-dev \
  && rm -rf /var/lib/apt/lists/*

RUN wget https://info-mongodb-com.s3.amazonaws.com/mongodb-bi/v2/mongodb-bi-linux-x86_64-ubuntu2004-v2.14.3.tgz \
  && tar -xvzf mongodb-bi-linux-x86_64-ubuntu2004-v2.14.3.tgz \
  && install -m755 mongodb-bi-linux-x86_64-ubuntu2004-v2.14.3/bin/mongo* /usr/local/bin/ \
  && rm -rf mongodb-bi-linux-x86_64-ubuntu2004-v2.14.3 mongodb-bi-linux-x86_64-ubuntu2004-v2.14.3.tgz

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]