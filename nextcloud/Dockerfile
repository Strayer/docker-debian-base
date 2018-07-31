FROM strayer/debian-base

ARG ENABLE_HETZNER_REPO
ARG APT_PROXY

# Install LibreOffice for thumbnails/previews
# Up here because it takes forever
RUN set -xe; \
    apt-update; \
    apt-get install -y --no-install-recommends libreoffice; \
    rm -rf /var/lib/apt/lists/*

# Install ffmpeg for thumbnails/previews
# Up here because it takes forever
RUN set -xe; \
    apt-update; \
    apt-get install -y --no-install-recommends ffmpeg; \
    rm -rf /var/lib/apt/lists/*

# Install various software
# exiftool: isabella-cron
# gawk: isabella-cron
# apt-transport-https: deb.sury.org
RUN set -xeu; \
    apt-update; \
    apt-get install --no-install-recommends -y \
            exiftool \
            gawk \
            apt-transport-https \
            nginx \
    ; \
    rm -rf /var/lib/apt/lists/*

# Install dcron
ARG DCRON_VERSION=4.5
ARG DCRON_CHECKSUM=9e50edb6f5bd8153b16bad05087d985e5153ce45cc01ae77e7f842213fb4a824
RUN set -xeu; \
    mkdir -p /tmp/dcron; \
    cd /tmp/dcron; \
    curl -L -o dcron.tar.gz "http://www.jimpryor.net/linux/releases/dcron-$DCRON_VERSION.tar.gz"; \
    echo "$DCRON_CHECKSUM  dcron.tar.gz" > checksum.txt; \
    apt-update; \
    apt-get install --no-install-recommends -y libdigest-sha-perl gcc make libc6-dev; \
    shasum -c checksum.txt; \
    tar xf dcron.tar.gz; \
    cd dcron*; \
    make PREFIX=/usr/local/dcron CRONTAB_GROUP=root; \
    make install; \
    cd; \
    rm -rf /tmp/dcron; \
    apt-get purge --auto-remove -y libdigest-sha-perl gcc make libc6-dev; \
    rm -rf /var/lib/apt/lists

# PHP 7.1 from Ondřej Surý (https://deb.sury.org/)
COPY sury-apt.gpg /etc/apt/trusted.gpg.d
RUN set -xe; \
    echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list; \
    apt-update; \
    apt-get install -y \
      php7.1-fpm \
      php7.1-cli \
      php7.1-xml \
      php7.1-gd \
      php7.1-mbstring \
      php7.1-zip \
      php7.1-pgsql \
      php7.1-curl \
      php7.1-bz2 \
      php7.1-intl \
      php7.1-mcrypt \
      php7.1-apcu \
      php7.1-redis \
      php7.1-imagick \
    ; \
    rm -rf /var/lib/apt/lists/*

# Configure PHP FPM
RUN set -xeu; \
    mkdir -p /run/php/; \
    sed -i 's/;daemonize = yes/daemonize = no/' /etc/php/7.1/fpm/php-fpm.conf; \
    sed -i 's!error_log = /var/log/php7.1-fpm.log!error_log = /proc/1/fd/2!' /etc/php/7.1/fpm/php-fpm.conf; \
    sed -i 's!pm.max_children = 5!pm.max_children = 10!' /etc/php/7.1/fpm/pool.d/www.conf; \
    sed -i 's!listen = /run/php/php7.1-fpm.sock!listen = 9000!' /etc/php/7.1/fpm/pool.d/www.conf; \
    sed -i 's!;chdir = /var/www!chdir = /var/www/nextcloud!' /etc/php/7.1/fpm/pool.d/www.conf; \
    sed -i 's!;catch_workers_output = yes!catch_workers_output = yes!' /etc/php/7.1/fpm/pool.d/www.conf; \
    sed -i 's!;clear_env = no!clear_env = no!' /etc/php/7.1/fpm/pool.d/www.conf; \
    { \
        echo 'opcache.enable=1'; \
        echo 'opcache.enable_cli=1'; \
        echo 'opcache.interned_strings_buffer=16'; \
        echo 'opcache.max_accelerated_files=10000'; \
        echo 'opcache.memory_consumption=256'; \
        echo 'opcache.save_comments=1'; \
        echo 'opcache.revalidate_freq=1'; \
        echo 'opcache.validate_timestamps=0'; \
    } > /etc/php/7.1/fpm/conf.d/opcache-recommended.ini;

# Add NextCloud GPG public key
COPY trustedkeys.gpg ./

ARG NEXTCLOUD_VERSION=13.0.2

# Install NextCloud
RUN set -xe; \
    curl -L -o nextcloud.tar.bz2 https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2; \
    curl -L -o nextcloud.tar.bz2.asc https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2.asc;  \
    gpgv --keyring `pwd`/trustedkeys.gpg nextcloud.tar.bz2.asc nextcloud.tar.bz2; \
    apt-update; \
    apt-get install -y bzip2; \
    tar xf nextcloud.tar.bz2; \
    apt-get purge -y --auto-remove bzip2; \
    rm -rf /var/lib/apt/lists/*; \
    mv nextcloud /var/www/nextcloud; \
    rm -rf /var/www/nextcloud/config/*; \
    chown www-data:www-data -R /var/www/nextcloud; \
    chmod u=rwX,og=rX -R /var/www/nextcloud; \
    rm nextcloud.tar.bz2* trustedkeys.gpg

COPY config/* /var/www/nextcloud/config/
RUN chown www-data:www-data /var/www/nextcloud/config/*

# Symlink custom apps volume
RUN ln -s /srv/custom_apps /var/www/nextcloud/custom_apps

# Configure dcron
COPY isabella-cron.sh /usr/local/bin/isabella-cron
COPY nextcloud-cron.sh /usr/local/bin/nextcloud-cron
COPY crontab /srv/dcron.d/crontab

# Configure nginx
COPY nginx.conf /etc/nginx/nginx.conf

COPY entrypoint.sh /usr/local/bin
ENTRYPOINT [ "tini", "--", "entrypoint.sh" ]

WORKDIR /var/www/nextcloud

CMD [ "php-fpm7.1" ]
