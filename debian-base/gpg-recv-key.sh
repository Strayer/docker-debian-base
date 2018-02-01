#!/usr/bin/env bash
set -e

gpg --keyserver ha.pool.sks-keyservers.net --keyserver-options timeout=5 --recv-keys "$1" || \
        gpg --keyserver pgp.mit.edu --keyserver-options timeout=5 --recv-keys "$1" || \
        gpg --keyserver keyserver.pgp.com --keyserver-options timeout=5 --recv-keys "$1"
