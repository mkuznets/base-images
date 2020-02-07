#!/usr/bin/env sh

: "${TUNNEL_URL?required environment variable}"
: "${TUNNEL_TARGET?required environment variable}"

if [ $# -eq 0 ]; then
    smee -u "$TUNNEL_URL" -t "$TUNNEL_TARGET"
else
    $@
fi
