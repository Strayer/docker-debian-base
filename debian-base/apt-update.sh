#!/usr/bin/env sh
set -eu

case $DISABLE_HETZNER_REPO in
  1|true)
    echo "Disabling Hetzner apt repository"
    sed -i "s_deb http://mirror.hetzner.de_# deb http://mirror.hetzner.de_" /etc/apt/sources.list
  ;;
esac

apt-get update

case $DISABLE_HETZNER_REPO in
  1|true)
    # Restore original sources.list
    sed -i "s_# deb http://mirror.hetzner.de_deb http://mirror.hetzner.de_" /etc/apt/sources.list
  ;;
esac
