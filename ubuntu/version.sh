#!/usr/bin/env bash

set -e

IMAGE="ubuntu-$(date +%s)"
docker build . -t "$IMAGE"

version=$(
  docker run --rm "$IMAGE" \
    sh -c 'echo $(. /etc/os-release && echo $VERSION_ID)'
)

docker rmi "$IMAGE"

echo
echo "ubuntu/${version}-$(date '+%Y.%m.%d')"
