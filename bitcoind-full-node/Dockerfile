FROM strayer/debian-base

ARG ENABLE_HETZNER_REPO
ARG APT_PROXY

ARG BITCOIN_CORE_VERSION=0.17.0

ARG BITCOIN_CORE_TGZ=bitcoin-${BITCOIN_CORE_VERSION}-x86_64-linux-gnu.tar.gz
ARG BITCOIN_CORE=https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_CORE_VERSION}/${BITCOIN_CORE_TGZ}
ARG BITCOIN_CORE_SIGS=https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_CORE_VERSION}/SHA256SUMS.asc
ARG APP_ROOT=/app

RUN create-user bitcoind $APP_ROOT

WORKDIR $APP_ROOT
VOLUME /data

COPY bitcoin.conf .bitcoin/

COPY trustedkeys.gpg .
RUN echo "Downloading Bitcoin Core…" && \
    curl -LO $BITCOIN_CORE && \
    curl -LO $BITCOIN_CORE_SIGS && \
    gpgv --keyring "$(pwd)/trustedkeys.gpg" SHA256SUMS.asc && \
    tar xf $BITCOIN_CORE_TGZ --strip 1 && \
    rm $BITCOIN_CORE_TGZ SHA256SUMS.asc && \
    rm -rf /root/.gnupg

USER bitcoind

CMD ["./bin/bitcoind"]
