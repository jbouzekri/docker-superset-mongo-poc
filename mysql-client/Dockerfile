FROM mysql:5.7

RUN apt-get update && apt-get install -y \
  wget \
  libgssapi-krb5-2 \
  rsyslog \
  openssl \
  libssl-dev \
  && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/mongodb/mongosql-auth-c/releases/download/v1.3.0/mongosql-auth-linux-x86_64-ubuntu-1604-v1.3.0.tgz \
  && tar xfz mongosql-auth-linux-x86_64-ubuntu-1604-v1.3.0.tgz \
  && mv mongosql-auth-linux-x86_64-ubuntu-1604/lib/mongosql_auth.so /usr/lib/mysql/plugin/ \
  && rm -rf mongosql-auth-linux-x86_64-ubuntu-1604 \
  && rm mongosql-auth-linux-x86_64-ubuntu-1604-v1.3.0.tgz

RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5.6_amd64.deb \
  && dpkg -i libssl1.0.0_1.0.2n-1ubuntu5.6_amd64.deb \
  && rm libssl1.0.0_1.0.2n-1ubuntu5.6_amd64.deb
