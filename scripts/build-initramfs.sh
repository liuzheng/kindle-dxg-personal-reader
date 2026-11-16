#!/bin/sh
# Package the local diagnostic initramfs only below out/. It never contacts a device.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
check_only=false
if [ "${1:-}" = "--check" ]; then
  check_only=true
elif [ "$#" -ne 0 ]; then
  echo "usage: $0 [--check]" >&2
  exit 64
fi

initramfs="$root/rootfs/initramfs"
busybox=${BUSYBOX:-$initramfs/bin/busybox}
[ -x "$initramfs/init" ] || { echo "missing executable initramfs init: $initramfs/init" >&2; exit 1; }
[ -x "$busybox" ] || { echo "missing static BusyBox: set BUSYBOX or provide $busybox" >&2; exit 1; }

if [ "$check_only" = true ]; then
  echo "initramfs prerequisites available"
  exit 0
fi

out="$root/out/initramfs"
mkdir -p "$out"
(
  cd "$initramfs"
  find . -print | LC_ALL=C sort | cpio -o -H newc > "$out/dxg-diagnostic.cpio"
)
gzip -n -f "$out/dxg-diagnostic.cpio"
echo "Created $out/dxg-diagnostic.cpio.gz"
