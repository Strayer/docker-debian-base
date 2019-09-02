FROM strayer/debian-base

ARG ENABLE_HETZNER_REPO
ARG APT_PROXY

ARG WORKDIR=/usr/src/app

ARG SYNCSERVER_COMMIT=e9b63a0871e9881a8985fe53f0c39fa79538b6e8
ARG SYNCSERVER_HASH=9609f31dd0150932feedef147ffb5d9629711e3658325a288df125472a80c5ff

WORKDIR $WORKDIR

# hadolint ignore=DL3013
RUN set -xe; \
  curl -L -o syncserver.tar.gz "https://github.com/mozilla-services/syncserver/archive/$SYNCSERVER_COMMIT.tar.gz"; \
  echo "$SYNCSERVER_HASH  syncserver.tar.gz" > checksum.txt; \
  sha256sum -c checksum.txt; \
  tar xf syncserver.tar.gz --strip 1; \
  rm syncserver.tar.gz checksum.txt; \
  apt-update; \
  apt-get install --no-install-recommends -y g++ python python-dev python-pip; \
  pip install --no-cache virtualenv pip; \
  virtualenv -p python2 venv; \
  export CFLAGS="-Wno-error -Wno-error=format-security"; \
  venv/bin/pip install --no-cache -r requirements.txt; \
  venv/bin/pip install --no-cache psycopg2-binary; \
  venv/bin/python ./setup.py develop; \
  sed -i "s/timeout = 30/timeout = 60\\nforwarded_allow_ips = */" syncserver.ini; \
  sed -i "s/workers = 1/workers = 2/" syncserver.ini; \
  sed -i "s;public_url = http://localhost:5000/;public_url = https://olle-orks.org/firefox-sync/;" syncserver.ini; \
  apt-get purge -y --auto-remove g++ python-dev python-pip; \
  rm -rf /var/lib/apt/lists/*

EXPOSE 5000

CMD [ "venv/bin/gunicorn", "--paste", "syncserver.ini" ]
