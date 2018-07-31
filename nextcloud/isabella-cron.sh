#!/usr/bin/env bash
set -eufo pipefail

SHARE=/strayer/files/Isabella

cd "/srv/data$SHARE"

format_unixtime() {
  gawk -v when="$1" 'BEGIN{ print strftime("%Y-%m", when); }'
}

CURRENT_MONTH_SUBFOLDER=$(format_unixtime "$(date +%s)")

echo "--- $(date) --- isabella-cron ---"

# Copy EXIF dates to c/mtime
TZ=Europe/Berlin exiftool "-FileCreateDate<DateTimeOriginal" "-FileModifyDate<DateTimeOriginal" -ext jpg . 2>&1 | grep -v "Warning: This tag is Windows only in File:FileCreateDate"
TZ=Europe/Berlin exiftool "-FileCreateDate<CreateDate" "-FileModifyDate<CreateDate" -ext mp4 . 2>&1 | grep -v "Warning: This tag is Windows only in File:FileCreateDate"

find . -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.mp4' \) -print0 | 
  while IFS= read -r -d $'\0' line; do
    file="${line##*/}"
    mtime=$(stat -c %Y "$file")
    subfolder=$(format_unixtime "$mtime")

    if [[ "$subfolder" != "$CURRENT_MONTH_SUBFOLDER" ]]; then
      echo "Moving $file to $subfolder"
      if [ ! -e "$subfolder" ]; then
        mkdir -p "$subfolder"
        chown www-data:www-data "$subfolder"
      fi
      mv "$file" "$subfolder/"
    fi
  done

cd /var/www/nextcloud
exec runuser -u www-data -- php occ files:scan --path="$SHARE"
