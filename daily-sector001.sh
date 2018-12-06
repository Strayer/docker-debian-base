#!/usr/bin/env bash
# shellcheck disable=SC1117
set -euo pipefail

TIME_START="$(date -u +%Y%m%dT%H%M%S)"
LOG_DIR="/var/log/docker-daily"
LOG_FILE_BUILD="$LOG_DIR/${TIME_START}_build.log"

PATH="$PATH:/usr/local/bin/"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# handles for build output
exec 3>&1
exec 4>&2

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "Usage: $(basename "${BASH_SOURCE[0]}") [--redirect-output]"
  exit 1;
fi

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

if [ "$1" == "--redirect-output" ]; then
  echo "Redirecting build output to $LOG_FILE_BUILD"
  exec 3> "$LOG_FILE_BUILD"
  exec 4>&3
fi

cd "$DIR"

# echo "==> Running backups"
# ./backup-sector001.sh

export ENABLE_HETZNER_REPO=1
export APT_PROXY=http://apt-cacher-ng:3142

echo "==> Building debian-base"
cd "$DIR/debian-base"
echo -e "###\ndebian-base\n###\n\n" >&3
./build.sh >&3 2>&4

echo "==> Building apt-cacher-ng"
cd "$DIR/apt-cacher-ng"
echo -e "\n\n###\napt-cacher-ng\n###\n\n" >&3
docker-compose -f docker-compose.yml -f production.yml build --pull --force-rm >&3 2>&4
docker-compose --no-ansi -f docker-compose.yml -f production.yml up -d

echo "==> Building syncthing"
cd "$DIR/syncthing"
echo -e "\n\n###\nsyncthing\n###\n\n" >&3
docker-compose -f docker-compose.yml -f production.yml build --force-rm >&3 2>&4
docker-compose --no-ansi -f docker-compose.yml -f production.yml up -d

echo "==> Building firefox-syncserver"
cd "$DIR/firefox-syncserver"
echo -e "\n\n###\nfirefox-syncserver\n###\n\n" >&3
docker-compose -f docker-compose.yml -f production.yml -f .secrets.yml pull >&3 2>&4
docker-compose -f docker-compose.yml -f production.yml -f .secrets.yml build --force-rm --pull >&3 2>&4
docker-compose --no-ansi -f docker-compose.yml -f production.yml -f .secrets.yml up -d

echo "==> Building fewo"
cd "$DIR/fewo-unter-eichen"
echo -e "\n\n###\fewo\n###\n\n" >&3
docker-compose pull >&3 2>&4
docker-compose build --pull --force-rm >&3 2>&4
docker-compose --no-ansi up -d

echo "==> Building influxdb"
cd "$DIR/influxdb"
echo -e "\n\n###\ninfluxdb\n###\n\n" >&3
docker-compose build --pull --no-cache --force-rm >&3 2>&4
docker-compose --compatibility --no-ansi up -d

echo "==> Cleanup docker"
docker image prune -f | grep -v "deleted: sha256:"

echo "==> Cleanup logfiles"
find $LOG_DIR -type f -mtime +30 -delete -print

echo "==> Done!"
