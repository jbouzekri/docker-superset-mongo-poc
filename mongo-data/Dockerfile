FROM mongo:5.0.1

RUN apt-get update && apt-get install -y \
  wget \
  openssl \
  libssl-dev \
  zip \
  && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh / \
      master_df.json /

ENTRYPOINT ["/entrypoint.sh"]