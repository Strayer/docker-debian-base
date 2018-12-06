#!/usr/bin/env sh
set -e

repository="strayer/debian-base"

export DOCKER_CONTENT_TRUST=1

docker build . --pull --no-cache \
    --rm --force-rm \
    --build-arg ENABLE_HETZNER_REPO="$ENABLE_HETZNER_REPO" \
    --build-arg APT_PROXY="$APT_PROXY" \
    --network apt-cacher-ng \
    -t $repository:latest

unset DOCKER_CONTENT_TRUST

docker push $repository:latest
