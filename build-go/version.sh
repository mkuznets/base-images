#!/usr/bin/env sh

set -e

GO=$(go version | cut -d' ' -f 3 | sed 's/^go//')
TS=$(TZ=Etc/UTC date '+%Y%m%d%H%M%S')

echo "${GO}-${TS}"
