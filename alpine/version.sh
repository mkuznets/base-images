#!/usr/bin/env bash

set -e

IMAGE="alpine-$(date +%s)"
docker build . -t "$IMAGE"

version=$(
  docker run --rm "$IMAGE" \
    sh -c 'echo $(. /etc/os-release && echo $VERSION_ID | cut -f1,2 -d".")'
)

docker rmi "$IMAGE"

echo
echo "alpine/${version}-$(date '+%Y.%m.%d')"
