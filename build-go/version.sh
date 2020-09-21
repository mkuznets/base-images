#!/usr/bin/env bash

set -e

IMAGE="build-go-$(date +%s)"
docker build . -t "$IMAGE"
raw_version=$(docker run --rm "$IMAGE" go version)
docker rmi "$IMAGE"

version=$(echo "$raw_version" | python -c 'import re; print(re.compile(r"go([\w\-.]+)").search(input()).group(1))')

echo
echo "build-go/${version}-$(date '+%Y.%m.%d')"
