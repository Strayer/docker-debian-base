FROM strayer/debian-base

ARG ENABLE_HETZNER_REPO
ARG APT_PROXY

ARG WORKDIR=/var/lib/syncthing

ARG SYNCTHING_VERSION=0.14.49

COPY trustedkeys.gpg /

RUN set -xe; \
    mkdir -p /tmp/syncthing; \
    cd /tmp/syncthing; \
    curl -L -O https://github.com/syncthing/syncthing/releases/download/v$SYNCTHING_VERSION/syncthing-linux-amd64-v$SYNCTHING_VERSION.tar.gz; \
    curl -L -O https://github.com/syncthing/syncthing/releases/download/v$SYNCTHING_VERSION/sha256sum.txt.asc; \
    sha256sum --ignore-missing -c sha256sum.txt.asc; \
    gpgv --keyring /trustedkeys.gpg sha256sum.txt.asc; \
    tar xf syncthing-linux-amd64-v$SYNCTHING_VERSION.tar.gz --strip 1; \
    mv syncthing /usr/local/bin; \
    cd -; \
    rm -r /tmp/syncthing /trustedkeys.gpg

RUN set -xe; \
    create-user syncthing $WORKDIR; \
    mkdir -p $WORKDIR; \
    chown syncthing:syncthing $WORKDIR
USER syncthing

WORKDIR $WORKDIR

# Ensure correct volume permissions
RUN mkdir $WORKDIR/config && chown syncthing:syncthing $WORKDIR/config

EXPOSE 8384 22000 21027/udp

ENV STNOUPGRADE=1
ENV STNODEFAULTFOLDER=1

CMD [ "syncthing", "-home", "config", "-gui-address", "0.0.0.0:8384" ]
