FROM mongo:5.0.1

RUN apt-get update && apt-get install -y \
  wget \
  openssl \
  libssl-dev \
  && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]