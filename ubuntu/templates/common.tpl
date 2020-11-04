FROM {{ base_image }}

LABEL maintainer="Max Kuznetsov <maks.kuznetsov@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/mkuznets/base-images"

COPY bin/setup.sh /tmp/

RUN \
    chmod +x /tmp/setup.sh && \
    /tmp/setup.sh && \
    rm /tmp/setup.sh

ENV DEBIAN_FRONTEND=noninteractive \
    LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en' \
    LC_ALL='en_US.UTF-8' \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 \
    TERM=xterm-color

ADD bin/set-timezone.sh /usr/local/bin/set-timezone
RUN chmod +x /usr/local/bin/set-timezone
