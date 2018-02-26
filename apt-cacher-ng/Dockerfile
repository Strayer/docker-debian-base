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

# Force apt-cacher-ng to write logs to stderr/stdout
RUN ln -sf /proc/1/fd/1 /var/log/apt-cacher-ng/apt-cacher.log && \
    ln -sf /proc/1/fd/2 /var/log/apt-cacher-ng/apt-cacher.err

VOLUME [ "/var/cache/apt-cacher-ng" ]
EXPOSE 3142

USER apt-cacher-ng

CMD ["apt-cacher-ng", "-c", "/etc/apt-cacher-ng"]
