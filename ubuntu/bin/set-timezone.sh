#!/usr/bin/env bash

if [ -z "$TIMEZONE" ]; then
  exit 0
fi

echo "$TIMEZONE" >/etc/timezone

# /etc/localtime has to be removed due to this bug
# https://bugs.launchpad.net/ubuntu/+source/tzdata/+bug/1554806
rm -f /etc/localtime

dpkg-reconfigure -f noninteractive tzdata
