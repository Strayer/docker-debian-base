#!/usr/bin/env bash
set -euo pipefail

PATH="$PATH:/usr/local/bin/"

BACKUP_TARGET_DIR="/mnt/shared/backup/docker-volumes"

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

echo "Backup up bitwarden sqlite"
cd /mnt/docker-volumes/bitwarden
sqlite3 db.sqlite3 ".backup '$BACKUP_TARGET_DIR/bitwarden/backup.$(date +%d-%m-%Y"_"%H_%M_%S).sqlite3'"
