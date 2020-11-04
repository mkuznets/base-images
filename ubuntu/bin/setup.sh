#!/usr/bin/env bash

set -xe

export DEBIAN_FRONTEND=noninteractive

apt-get update -q
apt-get install --yes --quiet --no-upgrade --no-install-recommends \
  locales \
  tzdata \
  make \
  tcpdump \
  wget \
  curl \
  less \
  git \
  vim-tiny \
  ca-certificates

locale-gen --purge en_US.UTF-8
ln -s /usr/bin/vi /usr/local/bin/vim

# ------------------------------------------------------------------------------
# su-exec

PKGS="gcc curl make libc6-dev"
apt-get install --yes --quiet --no-upgrade --no-install-recommends $PKGS

curl -L "https://api.github.com/repos/ncopa/su-exec/tarball/212b75144bbc06722fbd7661f651390dc47a43d1" | tar -xz -C /tmp

cd /tmp/ncopa-su-exec*
make
mv ./su-exec /usr/local/bin

cd /
rm -rf /tmp/ncopa-su-exec*
apt-get remove --yes --quiet --purge $PKGS
apt-get autoremove --purge --yes

# ------------------------------------------------------------------------------
# dumb-init

CHECKSUM="
45b1bbf56cc03edda81e4220535a025bfe3ed6e93562222b9be4471005b3eeb3 *dumb-init_1.2.2_aarch64
37f2c1f0372a45554f1b89924fbb134fc24c3756efaedf11e07f599494e0eff9 *dumb-init_1.2.2_amd64
45b1bbf56cc03edda81e4220535a025bfe3ed6e93562222b9be4471005b3eeb3 *dumb-init_1.2.2_arm64
88b02a3bd014e4c30d8d54389597adc4f5a36d1d6b49200b5a4f6a71026c2246 *dumb-init_1.2.2_ppc64el
88b02a3bd014e4c30d8d54389597adc4f5a36d1d6b49200b5a4f6a71026c2246 *dumb-init_1.2.2_ppc64le
8b3808c3c06d008b8f2eeb2789c7c99e0450b678d94fb50fd446b8f6a22e3a9d *dumb-init_1.2.2_s390x
37f2c1f0372a45554f1b89924fbb134fc24c3756efaedf11e07f599494e0eff9 *dumb-init_1.2.2_x86_64
"

ARCH="$(uname -m)"

wget "https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_$ARCH"
echo "$CHECKSUM" | grep -e "${ARCH}$" | sha256sum -c -
mv "dumb-init_1.2.2_$ARCH" /usr/local/bin/dumb-init

chmod +x /usr/local/bin/dumb-init

# ------------------------------------------------------------------------------
# Cleanup

apt-get clean
rm -rf /var/lib/apt/lists/*
