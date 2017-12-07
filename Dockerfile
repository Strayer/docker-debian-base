FROM debian:stretch

ARG TINI_VERSION=0.16.1

COPY gpg-recv-key.sh /usr/local/bin/gpg-recv-key

RUN apt-get update && \
    apt-get install -y wget gnupg bzip2 curl && \
    wget https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}-amd64.deb \
        https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}-amd64.deb.asc && \
    gpg-recv-key 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && \
    gpg --verify tini_${TINI_VERSION}-amd64.deb.asc && \
    dpkg -i tini_${TINI_VERSION}-amd64.deb && \
    rm -rf /root/.gnupg && \
    rm -rf /var/lib/apt/lists/*

COPY create-user.sh /usr/local/bin/create-user

ENTRYPOINT ["tini", "--"]
