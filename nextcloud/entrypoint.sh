#!/usr/bin/env bash
set -eufo pipefail

if [[ "$1" == "cron" ]]; then
  mkdir -p /tmp/empty
  exec /usr/local/dcron/sbin/crond \
       -f -M /bin/true -L /proc/1/fd/1 \
       -s /srv/dcron.d \
       -c /tmp/empty \
       -t /tmp/empty
else
  exec "$@"
fi
