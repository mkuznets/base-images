FROM ubuntu:focal-20200916

LABEL maintainer="Max Kuznetsov <maks.kuznetsov@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/mkuznets/base-images"

ADD etc /etc

RUN export DEBIAN_FRONTEND=noninteractive \
    && \
    VERSION=$(. /etc/os-release && echo $VERSION_CODENAME) && \
    sed -i "s/VERSION/${VERSION}/" /etc/apt/sources.list && \
    \
    apt-get update -q && \
    \
    apt-get install -y -q --no-upgrade --no-install-recommends \
        locales \
        localepurge \
        tzdata \
        make \
        tcpdump \
        wget \
        curl \
        less \
        dumb-init \
        git \
        vim-tiny \
        ca-certificates \
    && \
    locale-gen --purge en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    localepurge && \
    ln -s /usr/bin/vi /usr/local/bin/vim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en' \
    LC_ALL='en_US.UTF-8' \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 \
    TERM=xterm-color

ADD bin/set-timezone.sh /usr/local/bin/set-timezone
RUN chmod +x /usr/local/bin/set-timezone
