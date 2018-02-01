#!/usr/bin/env sh
set -e

if [ -z "$1" -o ! -e "$1" ]; then
    >&2 echo "Usage: build-trustedkeys.sh <public key file>"
    exit 1
fi

if [ -e trustedkeys.gpg ]; then
  rm trustedkeys.gpg
fi
# File needs to exists, otherwise Dockers bind mount will create a directory
touch trustedkeys.gpg

docker run --rm \
  -v "`pwd`/trustedkeys.gpg:/trustedkeys.gpg" \
  -v "`pwd`/$1:/pubkey.asc:ro" \
  alpine sh -c '
  set -eu; \
  apk --no-cache add gnupg && \
    touch /_trustedkeys.gpg && \
    gpg --no-default-keyring --keyring "/_trustedkeys.gpg" --import /pubkey.asc && \
    cat /_trustedkeys.gpg >> /trustedkeys.gpg
'
