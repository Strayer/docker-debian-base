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

echo "==> Running backups"
./backup-nibelungenhort.sh

echo "==> Building bitwarden"
cd "$DIR/bitwarden"
echo -e "\n\n###\nbitwarden\n###\n\n" >&3
docker-compose --no-ansi build --pull --no-cache >&3 2>&4
docker-compose --no-ansi up -d

echo "==> Cleanup docker"
docker image prune -f | grep -v "deleted: sha256:"
#docker system prune -f | grep -v "deleted: sha256:"

echo "==> Cleanup logfiles"
find "$LOG_DIR" -type f -mtime +30 -delete -print

echo "==> Done!"
