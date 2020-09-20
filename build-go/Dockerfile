FROM golang:1.15.2-alpine3.12

LABEL maintainer="Max Kuznetsov <maks.kuznetsov@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/mkuznets/base-images"

ENV \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    GO111MODULE="on"

RUN apk add --no-cache --update git bash curl && \
    rm -rf /var/cache/apk/*

RUN go version && \
    wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.31.0 && \
    golangci-lint --version && \
    go get github.com/mattn/goveralls@v0.0.4 && \
    go get github.com/rakyll/statik@v0.1.7
