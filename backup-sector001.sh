#!/usr/bin/env bash
set -euo pipefail

PATH="$PATH:/usr/local/bin/"

BACKUP_TARGET_DIR="/srv/docker/backup/"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

echo "Backing up firefox-syncserver postgresql..."
cd "$DIR/dockerfiles/firefox-syncserver"
docker-compose exec -T db \
  pg_dumpall -c -U postgres | \
  xz > "$BACKUP_TARGET_DIR/firefox-syncserver/firefox-syncserver_dump_$(date +%Y-%m-%d"_"%H_%M_%S).sql.xz"

echo "Cleanup old backups..."
find $BACKUP_TARGET_DIR -type f -mtime +60 -delete -print
