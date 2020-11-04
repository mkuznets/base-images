#!/usr/bin/dumb-init /bin/bash

uid="$(id -u)"

if [ "${uid}" -eq 0 ]; then
  # set container's time zone
  set-timezone
  chown -R "$APP_LOGIN:$APP_LOGIN" /srv
fi

if [[ -f "/srv/init.sh" ]]; then
  echo "starting /srv/init.sh"
  chmod +x /srv/init.sh

  if /srv/init.sh; then
    echo "/srv/init.sh failed"
    exit 1
  fi
fi

if [[ $# -eq 0 ]]; then
  echo "no arguments: starting root shell"
  exec /bin/bash
fi

echo "starting $*"
if [ "${uid}" -eq "0" ]; then
  exec su-exec "$APP_LOGIN" "$@"
else
  exec "$@"
fi
