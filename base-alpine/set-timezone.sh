#!/bin/sh

if [ -z "$TIMEZONE" ]; then
  exit 0
fi

cp "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
echo "$TIMEZONE" >/etc/timezone

echo "set timezone: $TIMEZONE ($(date))"
