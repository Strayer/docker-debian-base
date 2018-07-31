#!/usr/bin/env bash
set -eufo pipefail

echo "--- $(date) --- nextcloud-cron ---"

cd /var/www/nextcloud
exec runuser -u www-data -- php -f cron.php
