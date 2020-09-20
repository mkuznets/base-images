FROM alpine:3.12.0

LABEL maintainer="Max Kuznetsov <maks.kuznetsov@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/mkuznets/base-images"

ENV \
    TERM=xterm-color \
    APP_LOGIN=app \
    APP_UID=2000 \
    SUBSTITUTE_USER=1

RUN \
    apk add --no-cache --update \
        su-exec \
        tzdata \
        curl \
        ca-certificates \
        dumb-init \
    && \
    rm -rf /var/cache/apk/*

ADD set-timezone.sh /usr/local/bin/set-timezone
RUN \
    chmod +x /usr/local/bin/set-timezone && \
    TIMEZONE='Etc/UTC' set-timezone

ADD init.sh /init.sh
RUN \
    chmod +x /init.sh && \
    adduser -s /bin/sh -D -u $APP_UID $APP_LOGIN && \
    mkdir -p /srv/data && \
    chown -R $APP_LOGIN:$APP_LOGIN /srv

ENTRYPOINT ["/init.sh"]
