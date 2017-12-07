#!/usr/bin/env bash
set -e

echo "Creating user $1 with home $2…"

groupadd -g 1000 -r "$1"
useradd -u 1000 -r -g "$1" -d "$2" -s /sbin/nologin -c "Docker image user" "$1"
