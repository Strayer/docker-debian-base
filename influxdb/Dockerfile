FROM influxdb:1.5

RUN set -xe; \
  apt-get update; \
  apt-get full-upgrade -y; \
  rm -rf /var/lib/apt/lists/

RUN set -xe; \
  apt-get update; \
  apt-get install -y --no-install-recommends dumb-init; \
  rm -rf /var/lib/apt/lists/

USER influxdb

ENTRYPOINT [ "dumb-init", "--", "/entrypoint.sh" ]
CMD [ "influxd" ]
