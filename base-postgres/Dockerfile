FROM golang:1.13-alpine as go
ENV GO111MODULE="on"
RUN apk add --no-cache --update git bash curl && \
    rm -rf /var/cache/apk/* && \
    go get -ldflags "-s -w" github.com/jackc/tern@v1.8.2 && \
    test -e /go/bin/tern
FROM postgres:12.1-alpine
LABEL maintainer="Max Kuznetsov <maks.kuznetsov@gmail.com>"
COPY --from=go /go/bin/tern /usr/local/bin
ENV \
    PGDATA=/var/lib/postgresql/data/pgdata
COPY files/01-schema.sql /docker-entrypoint-initdb.d/01-schema.sql
