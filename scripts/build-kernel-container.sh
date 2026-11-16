#!/bin/sh
# Build the generic ARMv5 baseline inside the pinned Linux container.
# The Kindle is never contacted; all generated data stays under out/.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
image=${DXG_BUILD_IMAGE:-dxg-linux-build:bookworm-20261116}
mode=${1:-build}

case "$mode" in
  image)
    mkdir -p "$root/out/container"
    docker build --iidfile "$root/out/container/dxg-linux-build.iid" \
      --tag "$image" \
      --file "$root/container/Dockerfile" \
      "$root/container"
    ;;
  build)
    docker image inspect "$image" >/dev/null 2>&1 || {
      echo "missing local build image $image; run $0 image first" >&2
      exit 1
    }
    docker run --rm \
      --user "$(id -u):$(id -g)" \
      --env MAKE=make \
      --env CROSS_COMPILE=arm-linux-gnueabi- \
      --env JOBS="${JOBS:-2}" \
      --mount "type=bind,source=$root,target=/workspace" \
      --workdir /workspace \
      "$image" \
      ./scripts/build-kernel.sh
    ;;
  *)
    echo "usage: $0 [image|build]" >&2
    exit 64
    ;;
esac
