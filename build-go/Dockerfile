FROM golang:1.20.2-alpine

LABEL maintainer="Max Kuznetsov <maks.kuznetsov@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/mkuznets/base-images"

RUN apk add --no-cache --update ca-certificates git gcc musl-dev bash curl make && \
    rm -rf /var/cache/apk/*

ADD sqlite3-dummy /tmp/sqlite3-dummy
RUN ls /tmp && cd /tmp/sqlite3-dummy && \
    export CGO_ENABLED=1 && \
    go build -ldflags='-extldflags "-static"' -o a.out . && \
    rm -rf /tmp/sqlite3-dummy
