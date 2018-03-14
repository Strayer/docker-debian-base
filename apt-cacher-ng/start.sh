#!/usr/bin/env bash

_term() {
  echo "Terminating apt-cacher-ng…"
  kill -TERM "$child" 2>/dev/null
  wait "$child"
}

trap _term SIGTERM

# Start apt-cacher-ng
apt-cacher-ng -c /etc/apt-cacher-ng &
child=$!

tail -F /var/log/apt-cacher-ng/apt-cacher.{log,err}

wait "$child"
