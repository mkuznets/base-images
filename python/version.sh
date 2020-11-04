#!/usr/bin/env bash

set -e

PYTHON=$(python -c "import sys; print(\".\".join(map(str, sys.version_info[:2])))")
UBUNTU=$(. /etc/os-release && echo $ID)
DAY=$(TZ=Etc/UTC date '+%Y.%m.%d')

echo "${PYTHON}-${UBUNTU}-${DAY}"
