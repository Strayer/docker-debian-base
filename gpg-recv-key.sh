#!/usr/bin/env bash
set -e

gpg --keyserver pgp.mit.edu --recv-keys "$1" || \
        gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$1" || \
        gpg --keyserver keyserver.pgp.com --recv-keys "$1"
