#!/bin/sh
# Build the external DXG module scaffold against the local container kernel build.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
image=${DXG_BUILD_IMAGE:-dxg-linux-build:bookworm-20261116}
source_dir=/workspace/out/src/linux-6.18.63
build_dir=/workspace/out/build-armv5

docker image inspect "$image" >/dev/null 2>&1 || {
  echo "missing local build image $image; run scripts/build-kernel-container.sh image first" >&2
  exit 1
}
[ -f "$root/out/build-armv5/.config" ] || {
  echo "missing configured kernel output; run scripts/build-kernel-container.sh build first" >&2
  exit 1
}

docker run --rm \
  --user "$(id -u):$(id -g)" \
  --env ARCH=arm \
  --env CROSS_COMPILE=arm-linux-gnueabi- \
  --mount "type=bind,source=$root,target=/workspace" \
  --workdir /workspace \
  "$image" \
  make -C modules/dxg_legacy KSRC="$source_dir" KDIR="$build_dir"
