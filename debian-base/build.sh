#!/usr/bin/env sh
set -eu

repository="strayer/debian-base"
tag="`date -u +%s`"

docker build . --pull --no-cache -t $repository:$tag
docker tag $repository:$tag $repository:latest
docker push $repository:$tag
docker push $repository:latest
