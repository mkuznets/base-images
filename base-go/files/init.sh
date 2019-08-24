#!/usr/bin/dumb-init /bin/sh

UID=$(id -u)

if [[ ${UID} -eq 0 ]]; then
    echo "init container"
    # set container's time zone
    cp /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime
    echo "${TIME_ZONE}" >/etc/timezone
    echo "set timezone ${TIME_ZONE} ($(date))"
    chown -R $APP_USER:$APP_USER /srv /home/$APP_USER
fi

if [[ -f "/srv/init.sh" ]]; then
    echo "execute /srv/init.sh"
    chmod +x /srv/init.sh
    /srv/init.sh
    if [[ "$?" -ne "0" ]]; then
      echo "/srv/init.sh failed"
      exit 1
    fi
fi

echo "execute \"$@\""
if [[ ${UID} -eq 0 ]]; then
   su-exec $APP_USER $@
else
   exec $@
fi
