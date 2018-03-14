FROM strayer/debian-base

ARG ENABLE_HETZNER_REPO
ARG APT_PROXY

RUN apt-update && \
    apt-get install -y apt-cacher-ng && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i "s/# ForeGround: 0/ForeGround: 1/" /etc/apt-cacher-ng/acng.conf && \
    sed -i "s/Remap-/# Remap-/" /etc/apt-cacher-ng/acng.conf && \
    sed -i "s/# PassThroughPattern: \\.\\*/PassThroughPattern: .*/" /etc/apt-cacher-ng/acng.conf && \
    sed -i "s/# UnbufferLogs: 0/UnbufferLogs: 1/" /etc/apt-cacher-ng/acng.conf

# Allow Alpine packages
RUN sed -i "s_# VfilePatternEx:_VfilePatternEx: (/alpine/.*APKINDEX\\\\.tar\\\\.gz)_" /etc/apt-cacher-ng/acng.conf && \
    sed -i "s_# PfilePatternEx:_PfilePatternEx: (/alpine/.*\\\\.apk)_" /etc/apt-cacher-ng/acng.conf

# Add custom remaps
COPY backends_* /etc/apt-cacher-ng
RUN set -xe; \
  echo "Remap-sury_php: http://cached-sury_php ; file:backends_sury_php" >> /etc/apt-cacher-ng/acng.conf;

VOLUME [ "/var/cache/apt-cacher-ng", "/var/log/apt-cacher-ng/" ]
EXPOSE 3142

USER apt-cacher-ng

COPY start.sh /usr/local/bin/

CMD ["start.sh"]
