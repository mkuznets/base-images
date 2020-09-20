#!/usr/bin/env python3
from __future__ import annotations

import argparse
import dataclasses
import logging
import os
import pathlib
import re
import subprocess
import sys
from types import TracebackType
from typing import List, Optional, Type

# ------------------------------------------------------------------------------

logger = logging.getLogger("main")
logger.setLevel(logging.DEBUG)

if not logger.handlers:
    handler = logging.StreamHandler(sys.stderr)
    fmt = logging.Formatter("%(levelname)s\t%(message)s")
    handler.setFormatter(fmt)
    handler.setLevel(logging.DEBUG)
    logger.addHandler(handler)


# ------------------------------------------------------------------------------


@dataclasses.dataclass
class Repo:
    username: str
    password: str
    server: str
    prefix: str

    def token(self) -> str:
        if not (token := os.environ.get(self.password)):
            raise ValueError(f"{self.password} variable required")
        return token


@dataclasses.dataclass
class Image:
    TAG_RE = re.compile(r"([\w\-]+)/([\w\-.]+)$")
    SOURCE_LABEL = "org.opencontainers.image.source"

    name: str
    tag: str

    @property
    def dockerfile(self) -> pathlib.Path:
        return pathlib.Path(self.name) / "Dockerfile"

    @property
    def tmp_tag(self) -> str:
        return f"tmp-{self.name}:{self.tag}"

    def full_name(self, repo: Repo) -> str:
        return f"{repo.prefix}{self.name}"

    def validate(self) -> None:
        if not self.dockerfile.exists():
            raise ValueError(f"dockerfile not found: {self.dockerfile}")

        if self.SOURCE_LABEL not in self.dockerfile.read_text():
            raise ValueError(f"source repo label is required: {self.SOURCE_LABEL}")

    @classmethod
    def from_ref(cls, ref: str) -> Image:
        if (m := cls.TAG_RE.match(ref)) is None:
            raise ValueError("invalid tag")

        name, tag = m.groups()
        image = cls(name=name, tag=tag)
        image.validate()

        return image


class Docker:
    def __init__(self, repo: Repo):
        self.repo = repo
        self.__logged_in = False

    def __enter__(self) -> Docker:
        r = subprocess.run(
            [
                "docker",
                "login",
                self.repo.server,
                "-u",
                self.repo.username,
                "--password-stdin",
            ],
            input=self.repo.token().encode(),
            timeout=30,
        )
        r.check_returncode()
        self.__logged_in = True
        return self

    @staticmethod
    def has_image(tag: str) -> bool:
        output = subprocess.check_output(
            ["docker", "images", "--format", "{{.Tag}}", tag]
        )
        return bool(output.strip())

    @staticmethod
    def command(*args: str) -> subprocess.CompletedProcess[bytes]:
        exec_args = ["docker", *args]
        logger.debug("Running: %s", exec_args)
        p = subprocess.run(exec_args)
        p.check_returncode()
        return p

    def __exit__(
        self,
        exc_type: Optional[Type[BaseException]],
        exc_val: Optional[BaseException],
        exc_tb: Optional[TracebackType],
    ) -> None:
        if self.__logged_in:
            self.command("logout", self.repo.server)


# ------------------------------------------------------------------------------


REPOS = [
    Repo(
        username="mkznts",
        password="DOCKER_TOKEN",
        server="docker.io",
        prefix="mkznts/",
    ),
    Repo(
        username="mkuznets",
        password="GHCR_TOKEN",
        server="ghcr.io",
        prefix="ghcr.io/mkuznets/",
    ),
]


def main(ref: str) -> None:
    image = Image.from_ref(ref)

    for repo in REPOS:
        latest_tag = f"{image.full_name(repo)}:latest"
        release_tag = f"{image.full_name(repo)}:{image.tag}"

        with Docker(repo) as docker:

            if not docker.has_image(image.tmp_tag):
                if not docker.has_image(latest_tag):
                    # Prefetch the latest image for build cache
                    subprocess.run(["docker", "pull", latest_tag])
                cache_args: List[str] = []
                if docker.has_image(latest_tag):
                    cache_args.extend(("--cache-from", latest_tag))

                docker.command(
                    "build",
                    image.name,
                    "-f",
                    str(image.dockerfile),
                    "-t",
                    image.tmp_tag,
                    *cache_args,
                )

            for tag in (release_tag, latest_tag):
                docker.command("tag", image.tmp_tag, tag)
                docker.command("push", tag)

            docker.command("rmi", image.tmp_tag)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("ref", help="git tag in the format <image-name>/<version>")

    args_ = parser.parse_args()
    main(args_.ref)
