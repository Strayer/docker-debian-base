#!/usr/bin/env sh
set -e

# Always use default stretch sources.list
cp /config/sources.list-stretch /etc/apt/sources.list

# Local Hetzner repositories (not publicly accessible)
case $ENABLE_HETZNER_REPO in
  1|true)
    echo "Using Hetzner apt mirror"
    cat /config/sources.list-hetzner > /etc/apt/sources.list
    cat /config/sources.list-stretch >> /etc/apt/sources.list
  ;;
  *) true ;;
esac

case $APT_PROXY in
  (*[![:blank:]]*)
    cleaned_apt_proxy=`echo ${APT_PROXY} | sed "s:/*$:/:"`
    echo "Using apt proxy: $cleaned_apt_proxy"
    sed -i "s_deb[[:space:]]*http://_deb ${cleaned_apt_proxy}_" /etc/apt/sources.list
    cat /etc/apt/sources.list
  ;;
esac

apt-get update
