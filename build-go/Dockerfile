FROM golang:1.12-alpine
LABEL maintainer="Maxim Kuznetsov <maks.kuznetsov@gmail.com>"

ENV \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

RUN \
    apk add --no-cache --update git bash curl && \
    rm -rf /var/cache/apk/*
RUN \
    go version && \
    go get -u -v github.com/securego/gosec && \
    go get -u -v github.com/jteeuwen/go-bindata/... && \
    go get -u -v github.com/stretchr/testify && \
    go get -u -v github.com/vektra/mockery/.../
RUN \
    go get -u -v github.com/golangci/golangci-lint/cmd/golangci-lint && \
    cd /go/src/github.com/golangci/golangci-lint && \
    git checkout v1.17.1 && \
    cd /go/src/github.com/golangci/golangci-lint/cmd/golangci-lint && \
    go install -ldflags "-X 'main.version=$(git describe --tags)' -X 'main.commit=$(git rev-parse --short HEAD)' -X 'main.date=$(date)'" && \
    golangci-lint --version
RUN \
    go get -u -v github.com/mattn/goveralls && \
    cd /go/src/github.com/mattn/goveralls && \
    git checkout v0.0.2 && \
    go install github.com/mattn/goveralls
RUN \
    go get -u -v github.com/rakyll/statik && \
    cd /go/src/github.com/rakyll/statik && \
    git checkout v0.1.5 && \
    go install github.com/rakyll/statik
