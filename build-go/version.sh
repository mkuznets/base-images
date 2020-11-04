#!/usr/bin/env sh

set -e

GO=$(go version | cut -d' ' -f 3 | sed 's/^go//')
DAY=$(TZ=Etc/UTC date '+%Y.%m.%d')

echo "${GO}-${DAY}"
