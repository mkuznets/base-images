#!/usr/bin/env python3

import os
import re
import subprocess
import sys
from itertools import chain

TAG_RE = re.compile(r'([\w\-]+)-([\d.]+)$')

HUB_USER = 'mkznts'


def has_image(tag: str) -> bool:
    output = subprocess.check_output(['docker', 'images', '--format', '{{.Tag}}', tag])
    return bool(output.strip())


if __name__ == '__main__':

    if len(sys.argv) < 2:
        print("ref is required")
        sys.exit(1)

    ref = sys.argv[1]

    m = TAG_RE.match(ref)

    if m is None:
        print("invalid tag")
        sys.exit(1)

    image, tag = m.groups()
    dockerfile = os.path.join(image, 'Dockerfile')

    if not os.path.exists(dockerfile):
        print("invalid image name")
        sys.exit(1)

    token = os.environ.get("DOCKER_TOKEN")
    if not token:
        print("DOCKER_TOKEN is required")
        sys.exit(1)

    try:
        r = subprocess.run(
            ['docker', 'login', '-u', HUB_USER, '--password-stdin'],
            input=token.encode(), timeout=30
        )
        if r.returncode:
            sys.exit(r.returncode)

        full_tags = [
            f'{HUB_USER}/{image}:{tag}',
            f'{HUB_USER}/{image}:latest',
        ]

        latest_tag = full_tags[-1]

        if not has_image(latest_tag):
            # Prefetch the latest image for build cache
            subprocess.run(['docker', 'pull', latest_tag])

        cache_args = []
        if has_image(latest_tag):
            cache_args.extend(('--cache-from', latest_tag))

        tag_args = chain.from_iterable(('-t', t) for t in full_tags)

        r = subprocess.run([
            'docker', 'build', image, '-f', dockerfile,
            *tag_args,
            *cache_args,
        ])
        if r.returncode:
            sys.exit(r.returncode)

        for tag in full_tags:
            r = subprocess.run(['docker', 'push', tag])
            if r.returncode:
                sys.exit(r.returncode)

    finally:
        subprocess.run(['docker', 'logout'])
