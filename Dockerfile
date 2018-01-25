FROM debian:stretch

ARG TINI_VERSION=0.16.1
ARG CONTAINER_USER_UID=998
ENV CONTAINER_USER_UID=$CONTAINER_USER_UID
ARG CONTAINER_USER_GID=998
ENV CONTAINER_USER_GID=$CONTAINER_USER_GID

COPY sources.list /etc/apt/

COPY gpg-recv-key.sh /usr/local/bin/gpg-recv-key

RUN apt-get update && \
    apt-get full-upgrade -y && \
    apt-get install -y wget gnupg bzip2 curl aria2 && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir $HOME/.aria2 && echo "summary-interval=10" > $HOME/.aria2/aria2.conf

RUN aria2c -Z https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-amd64 \
        https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-amd64.asc && \
    gpg-recv-key 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && \
    gpg --verify tini-amd64.asc && \
    mv tini-amd64 /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini && \
    rm tini-amd64.asc && \
    rm -rf /root/.gnupg

COPY create-user.sh /usr/local/bin/create-user

ENTRYPOINT ["tini", "--"]
