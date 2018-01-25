#!/usr/bin/env sh
set -eu

REPOSITORY="strayer/debian-base"
TAG="`date -u +%s`"

docker build . --pull --no-cache -t $REPOSITORY:$TAG
docker tag $REPOSITORY:$TAG $REPOSITORY:latest
docker push $REPOSITORY:$TAG
docker push $REPOSITORY:latest
