#!/usr/bin/env sh

echo "[INFO] start nginx"

# Set TZ
cp "/usr/share/zoneinfo/${TZ}" /etc/localtime && echo "${TZ}" >/etc/timezone

if [ ! -d "/ssl" ]; then
  echo "[ERR] /ssl has to be volume-mounted"
  return 1
fi

if [ "$(find /etc/nginx/ -maxdepth 1 -type f -name "service*.conf" | wc -l)" = "0" ]; then
  echo "[ERR] could not find any mounted service configs: /etc/nginx/service*.conf"
  return 1
fi

mkdir -p /etc/nginx/conf.d

# Generate dhparams.pem
DHPARAMS="/ssl/dhparams.pem"
if [ ! -f $DHPARAMS ]; then
  echo "[INFO] create dhparams"
  openssl dhparam -out $DHPARAMS 2048 && chmod 600 $DHPARAMS
fi

if [ "$LE" = "true" ]; then
  echo "[INFO] letsencrypt: enabled for domains: ${LE_FQDN}"
  domains=$(echo "${LE_FQDN}" | idn -a | tr '*' '_' | tr ',' '\n')
  args=""
  for domain in $domains; do
    args="${args} -d $domain"
  done
  first_domain=$(echo "$LE_FQDN" | cut -d"," -f1)

  cert="/ssl/certificates/${first_domain}.crt"

  # Register and obtain certs for the first time
  if [ ! -f "$cert" ]; then
    echo "[INFO] letsencrypt: could not find ${first_domain}.crt, trying to get it"
    lego -a -m "$LE_EMAIL" --dns "$LE_DNS_PROVIDER" --dns.disable-cp --path /ssl $args run --must-staple
    if [ ! -f "$cert" ]; then
      echo "[ERR] letsencrypt: could not get certificate"
      return 1
    fi
  fi

  echo "[INFO] letsencrypt: using ${cert}"

  (
    echo "[INFO] letsencrypt: start daily updater"
    sleep 5
    while :; do
      echo "[INFO] letsencrypt: trying to renew certificates"
      lego -a -m "$LE_EMAIL" --dns "$LE_DNS_PROVIDER" --dns.disable-cp --path /ssl $args renew --must-staple --days 30 --renew-hook "nginx -s reload"
      echo "[INFO] letsencrypt: going to sleep for 24h until the next renewal"
      sleep 1d
    done
  ) &

  export SSL_CERT="$cert"
  export SSL_CHAIN_CERT="$cert"
  export SSL_KEY="/ssl/certificates/${first_domain}.key"
fi

find /etc/nginx/ -maxdepth 1 -type f -name "service*.conf" -exec \
  sh -c 'envsubst \$SSL_CERT,\$SSL_CHAIN_CERT,\$SSL_KEY < "$1" > "/etc/nginx/conf.d/$(basename $1)"' _ {} \;

nginx -g "daemon off;"
