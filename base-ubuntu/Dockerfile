FROM ubuntu:20.04
LABEL maintainer="Max Kuznetsov <maks.kuznetsov@gmail.com>"

ADD sources.txt /etc/apt/sources.list
ADD locale.nopurge /etc/locale.nopurge

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -q \
    && apt-get install -y -q --no-upgrade --no-install-recommends \
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
    \
    && locale-gen --purge en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && localepurge \
    && ln -s /usr/bin/vi /usr/local/bin/vim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en' \
    LC_ALL='en_US.UTF-8' \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 \
    TERM=xterm-color

ADD set-timezone.sh /usr/local/bin/set-timezone
RUN chmod +x /usr/local/bin/set-timezone
