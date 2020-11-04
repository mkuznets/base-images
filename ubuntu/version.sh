#!/usr/bin/env bash

set -e

UBUNTU=$(. /etc/os-release && echo "$VERSION_ID")
DAY=$(TZ=Etc/UTC date '+%Y.%m.%d')

echo "${UBUNTU}-${DAY}"
