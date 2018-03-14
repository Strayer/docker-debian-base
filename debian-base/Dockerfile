FROM debian:stretch

ARG ENABLE_HETZNER_REPO
ARG APT_PROXY
ARG TINI_VERSION=0.16.1
ARG CONTAINER_USER_UID=998
ENV CONTAINER_USER_UID=$CONTAINER_USER_UID
ARG CONTAINER_USER_GID=998
ENV CONTAINER_USER_GID=$CONTAINER_USER_GID

ARG TINI_URL=https://github.com/krallin/tini/releases/download/v${TINI_VERSION}

COPY sources.list /etc/apt/sources.list
COPY apt-update.sh /usr/local/sbin/apt-update

COPY gpg-recv-key.sh /usr/local/bin/gpg-recv-key

RUN echo 'Dir::Ignore-Files-Silently:: "(.__apt_proxy_backup)$";' \
    > /etc/apt/apt.conf.d/99_ignore-apt-proxy-backup

RUN apt-update && \
    apt-get full-upgrade -y && \
    apt-get install -y wget gnupg bzip2 curl aria2 && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir $HOME/.aria2 && echo "summary-interval=10" > $HOME/.aria2/aria2.conf

COPY trustedkeys.gpg .
RUN curl -LOO "${TINI_URL}/{tini-amd64,tini-amd64.asc}" && \
    gpgv --keyring `pwd`/trustedkeys.gpg tini-amd64.asc tini-amd64 && \
    mv tini-amd64 /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini && \
    rm tini-amd64.asc trustedkeys.gpg && \
    rm -rf /root/.gnupg

COPY create-user.sh /usr/local/bin/create-user

ENTRYPOINT ["tini", "--"]
