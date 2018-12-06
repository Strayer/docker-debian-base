FROM debian:stretch

ARG ENABLE_HETZNER_REPO
ARG APT_PROXY
ARG CONTAINER_USER_UID=999
ENV CONTAINER_USER_UID=$CONTAINER_USER_UID
ARG CONTAINER_USER_GID=999
ENV CONTAINER_USER_GID=$CONTAINER_USER_GID

COPY sources.list /etc/apt/sources.list
COPY apt-update.sh /usr/local/sbin/apt-update

RUN echo 'Dir::Ignore-Files-Silently:: "(.__apt_proxy_backup)$";' \
    > /etc/apt/apt.conf.d/99_ignore-apt-proxy-backup

RUN apt-update && \
    apt-get full-upgrade -y && \
    apt-get install -y --no-install-recommends curl ca-certificates dumb-init && \
    rm -rf /var/lib/apt/lists/*

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY create-user.sh /usr/local/bin/create-user

ENTRYPOINT ["dumb-init", "--"]
