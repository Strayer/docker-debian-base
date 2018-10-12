#!/usr/bin/env bash
set -eo pipefail

enable_apt_proxy_for_file() {
  if test ! -e "$2__apt_proxy_backup"; then
    cp "$2" "$2__apt_proxy_backup"
    sed -i "s_deb[[:space:]]*http://_deb $1_" "$2"
    sed -i "s_deb[[:space:]]*https://_deb $1HTTPS///_" "$2"
  fi
}

reset_apt_proxy_for_file() {
  if test -e "$1__apt_proxy_backup"; then
    mv "$1__apt_proxy_backup" "$1"
  fi
}

case $APT_PROXY in
  (*[![:blank:]]*)
    # Make sure there is exactly one / at the end of the APT_PROXY URL
    # shellcheck disable=SC2001
    cleaned_apt_proxy=$(echo "${APT_PROXY}" | sed "s:/*$:/:")

    echo "Using apt proxy: $cleaned_apt_proxy"
    enable_apt_proxy_for_file "$cleaned_apt_proxy" "/etc/apt/sources.list"

    if test -n "$(find /etc/apt/sources.list.d -maxdepth 1 -name '*.list' -print -quit)"; then
      for file in /etc/apt/sources.list.d/*.list; do
        enable_apt_proxy_for_file "$cleaned_apt_proxy" "$file"
      done
    fi
  ;;
  *)
    reset_apt_proxy_for_file "/etc/apt/sources.list"

    if test -n "$(find /etc/apt/sources.list.d -maxdepth 1 -name '*.list' -print -quit)"; then
      for file in /etc/apt/sources.list.d/*.list; do
        reset_apt_proxy_for_file "$file"
      done
    fi
  ;;
esac

# Local Hetzner repositories (not publicly accessible)
case $ENABLE_HETZNER_REPO in
  1|true)
    echo "Enabling Hetzner apt mirror"
    # shellcheck disable=SC1117
    sed -i "s_^# deb http://\(.*\)mirror.hetzner.de/_deb http://\\1mirror.hetzner.de/_" /etc/apt/sources.list
  ;;
  *)
    # shellcheck disable=SC1117
    sed -i "s_^deb http://\(.*\)mirror.hetzner.de/_# deb http://\\1mirror.hetzner.de/_" /etc/apt/sources.list
  ;;
esac

apt-get update
