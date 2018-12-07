FROM strayer/debian-base

ARG ENABLE_HETZNER_REPO
ARG APT_PROXY

RUN set -xeu; \
    apt-update; \
    apt-get install --no-install-recommends -y \
            nginx nginx-extras \
    ; \
    rm -rf /var/lib/apt/lists/*

COPY ./nginx.conf /etc/nginx/nginx.conf

COPY ./olle-orks.org /var/www/olle-orks.org
COPY ./grunewaldt.de /var/www/grunewaldt.de

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

STOPSIGNAL SIGTERM

CMD [ "nginx" ]
