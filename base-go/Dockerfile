FROM alpine:3.10
LABEL maintainer="Maxim Kuznetsov <maks.kuznetsov@gmail.com>"
ENV \
    TERM=xterm-color \
    TIME_ZONE=Europe/Moscow \
    APP_USER=app \
    APP_UID=2000
COPY files/init.sh /init.sh
RUN \
    chmod +x /init.sh && \
    apk add --no-cache --update su-exec tzdata curl ca-certificates dumb-init && \
    mkdir -p /home/$APP_USER && \
    adduser -s /bin/sh -D -u $APP_UID $APP_USER && \
    mkdir -p /srv/data && chown -R $APP_USER:$APP_USER /srv && \
    cp /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && \
    echo "${TIME_ZONE}" > /etc/timezone && date && \
    rm -rf /var/cache/apk/*
ENTRYPOINT ["/init.sh"]
