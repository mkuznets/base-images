#!/usr/bin/dumb-init /bin/sh

uid=$(id -u)

if [ "${uid}" -eq "0" ]; then
  set-timezone
  chown -R "$APP_LOGIN:$APP_LOGIN" /srv
fi

if [ -f "/srv/init.sh" ]; then
  echo "running: /srv/init.sh"
  chmod +x /srv/init.sh

  if ! /srv/init.sh; then
    echo "/srv/init.sh failed"
    exit 1
  fi
fi

if [ $# -eq 0 ]; then
  echo "no arguments: running $(whoami) shell"
  exec /bin/sh
fi

if [ "${uid}" -ne "$APP_UID" ] && [ "$SUBSTITUTE_USER" -eq "1" ]; then
  echo "running as $APP_LOGIN: $*"
  su-exec "$APP_LOGIN" "$@"
else
  echo "running as $(whoami): $*"
  exec "$@"
fi
