#!/usr/bin/env sh
set -e

if [ -z "$1" ] || [ ! -e "$1" ]; then
    >&2 echo "Usage: build-trustedkeys.sh <public key file>"
    exit 1
fi

[ -e trustedkeys.gpg ] && rm trustedkeys.gpg
# File needs to exists, otherwise Dockers bind mount will create a directory
touch trustedkeys.gpg

# shellcheck disable=SC1004
docker run --rm \
  -v "$(pwd)/trustedkeys.gpg:/trustedkeys.gpg" \
  -v "$(pwd)/$1:/pubkey.asc:ro" \
  alpine sh -c '
  set -eu; \
  apk --no-cache add gnupg && \
    touch /_trustedkeys.gpg && \
    gpg --no-default-keyring --keyring "/_trustedkeys.gpg" --import /pubkey.asc && \
    cat /_trustedkeys.gpg >> /trustedkeys.gpg
'
