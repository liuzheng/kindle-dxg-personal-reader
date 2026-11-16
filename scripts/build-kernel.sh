#!/bin/sh
# Build a generic ARMv5 baseline locally. Never packages or deploys Kindle updates.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
check_only=false
if [ "${1:-}" = "--check" ]; then
  check_only=true
elif [ "$#" -ne 0 ]; then
  echo "usage: $0 [--check]" >&2
  exit 64
fi

cd "$root"
(cd "$root/reference" && shasum -a 256 -c ARTIFACTS.sha256)
if [ "$check_only" = true ]; then
  "$root/scripts/check-host.sh" --report-only
else
  "$root/scripts/check-host.sh"
fi
"$root/scripts/check-patch-series.sh" "$root/patches/series"

if [ "$check_only" = true ]; then
  echo "check-only: source extraction and compilation intentionally skipped"
  exit 0
fi

make_bin=${MAKE:-gmake}
: "${CROSS_COMPILE:=arm-none-eabi-}"
export CROSS_COMPILE
source_archive="$root/reference/linux-6.18.63.tar.xz"
source_dir="$root/out/src/linux-6.18.63"
build_dir="$root/out/build-armv5"

if [ ! -d "$source_dir" ]; then
  mkdir -p "$root/out/src"
  tar -xJf "$source_archive" -C "$root/out/src"
fi

mkdir -p "$build_dir"
export ARCH=arm
export KBUILD_BUILD_USER=dxg
export KBUILD_BUILD_HOST=local
export KBUILD_BUILD_TIMESTAMP='1970-01-01 00:00:00 UTC'
"$make_bin" -C "$source_dir" O="$build_dir" imx_v4_v5_defconfig
# Do not use upstream merge_config.sh: its GNU readlink -m dependency is absent on macOS.
# Kconfig consumes later duplicate values from this reviewed local-only fragment.
cat "$root/configs/dxg.config.fragment" >> "$build_dir/.config"
"$make_bin" -C "$source_dir" O="$build_dir" olddefconfig
"$make_bin" -C "$source_dir" O="$build_dir" -j"${JOBS:-2}" zImage modules dtbs

echo "Local generic i.MX ARMv5 build complete: $build_dir"
echo "This output is not a verified DXG image and must not be deployed."
