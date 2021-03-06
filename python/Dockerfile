FROM mkznts/ubuntu:20.04-2020.11.04

LABEL maintainer="Max Kuznetsov <maks.kuznetsov@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/mkuznets/base-images"

ENV \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONFAULTHANDLER=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=true \
    PIP_NO_CACHE_DIR=off \
    APP_LOGIN=app \
    APP_UID=2000

RUN \
    apt-get update -q \
    \
    && apt-mark hold \
        python2 \
        python2-minimal \
        python2.7 \
        python2.7-minimal \
        libpython2-stdlib \
        libpython2.7-minimal \
        libpython2.7-stdlib \
    \
    && apt-get install -y -q --no-upgrade --no-install-recommends \
        build-essential \
        python-is-python3 \
        python3-venv \
        libpython3-dev \
        libpq-dev \
    \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD init.sh /init.sh
RUN \
    useradd -u ${APP_UID} ${APP_LOGIN} \
    && mkdir -p /srv \
    && chown -R $APP_LOGIN:$APP_LOGIN /srv \
    && chmod +x /init.sh

ENTRYPOINT ["/init.sh"]
