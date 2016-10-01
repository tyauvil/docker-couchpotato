FROM alpine

MAINTAINER ty.auvil@gmail.com

ENV DUMB_VERSION=1.1.3 \
    COUCH_URL=https://github.com/CouchPotato/CouchPotatoServer/archive/build/3.0.1.tar.gz \
    CONFIG_FILE=/config/config.ini \
    DATADIR=/config/data \
    PUID=1000 \
    PGID=1000 \
    USERNAME=couchpotato

ADD https://github.com/Yelp/dumb-init/releases/download/v${DUMB_VERSION}/dumb-init_${DUMB_VERSION}_amd64 /bin/dumb-init

COPY docker-entrypoint.sh /bin/docker-entrypoint.sh

RUN apk --no-cache add curl python py-pip py-lxml py-cffi openssl su-exec && \
    apk --no-cache add build-base openssl-dev python-dev py-setuptools --virtual /tmp/build-deps && \
    pip install pyopenssl && \
    mkdir -p /opt /media /downloads /config && \
    cd /opt && \
    curl -kLo couch.tar.gz "${COUCH_URL}" && \
    tar xf couch.tar.gz && \
    rm -f couch.tar.gz && \
    mv Couch* couchpotato && \
    apk del curl /tmp/build-deps && \
    rm -f /tmp/build-deps && \
    chmod +x /bin/docker-entrypoint.sh /bin/dumb-init

VOLUME /media /downloads /config

WORKDIR /opt/couchpotato

ENTRYPOINT ["/bin/docker-entrypoint.sh"]
