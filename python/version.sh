#!/usr/bin/env bash

set -e

IMAGE="python-$(date +%s)"
docker build . -t "$IMAGE"

version=$(
  docker run --rm "$IMAGE" \
    sh -c 'echo $(python -c "import sys; print(\".\".join(map(str, sys.version_info[:2])))")-$(. /etc/os-release && echo $ID)'
)

docker rmi "$IMAGE"

echo
echo "python/${version}-$(date '+%Y.%m.%d')"
