#!/bin/sh
# Package the diagnostic initramfs using the static ARM BusyBox in the build image.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
image=${DXG_BUILD_IMAGE:-dxg-linux-build:bookworm-20261116}

docker image inspect "$image" >/dev/null 2>&1 || {
  echo "missing local build image $image; run scripts/build-kernel-container.sh image first" >&2
  exit 1
}

docker run --rm \
  --user "$(id -u):$(id -g)" \
  --env BUSYBOX=/bin/busybox \
  --mount "type=bind,source=$root,target=/workspace" \
  --workdir /workspace \
  "$image" \
  ./scripts/build-initramfs.sh
