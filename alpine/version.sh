#!/usr/bin/env sh

set -e

ALPINE=$(. /etc/os-release && echo $VERSION_ID | cut -f1,2 -d".")
DAY=$(TZ=Etc/UTC date '+%Y.%m.%d')

echo "${ALPINE}-${DAY}"
