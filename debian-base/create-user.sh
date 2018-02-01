#!/usr/bin/env sh
set -eu

echo "Creating user $1 with home $2…"

groupadd -g "$CONTAINER_USER_GID" -r "$1"
useradd -u "$CONTAINER_USER_UID" -r -g "$1" -d "$2" -s /sbin/nologin -c "Docker image user" "$1"
