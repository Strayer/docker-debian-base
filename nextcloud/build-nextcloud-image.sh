#!/usr/bin/env bash
set -efo pipefail

if [[ "$1" == "--no-cache" ]]; then
  docker_build() {
    docker build --no-cache "$@"
  }
else
  docker_build() {
    docker build "$@"
  }
fi

docker_build . \
       --build-arg ENABLE_HETZNER_REPO="$ENABLE_HETZNER_REPO" \
       --build-arg APT_PROXY="$APT_PROXY" \
       --network apt-cacher-ng \
       -t local/nextcloud:latest
