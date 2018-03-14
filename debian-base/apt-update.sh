#!/usr/bin/env sh
set -e

# Always use default stretch sources.list
cp /config/sources.list-stretch /etc/apt/sources.list

# Copy over additional sources
if test -n "$(find /docker/sources.list.d -maxdepth 1 -name '*.list' -print -quit 2>/dev/null)"; then
  cp /docker/sources.list.d/*.list /etc/apt/sources.list.d/
fi

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

    # put APT_PROXY in docker managed sources.list.d lists
    # changing other source lists will cause them to not reset when run without
    # APT_PROXY later, since only those in /docker/sources.list.d always get
    # reset when this script runs
    if test -n "$(find /etc/apt/sources.list.d -maxdepth 1 -name '*.list' -print -quit)"; then
      for file in /etc/apt/sources.list.d/*.list; do
        if test -e /docker/sources.list.d/${file##*/}; then
          sed -r -i "s;deb[[:space:]]*https?://packages.sury.org/php/?;deb ${cleaned_apt_proxy}cached-sury_php;" $file
        fi
      done
    fi
  ;;
esac

apt-get update
