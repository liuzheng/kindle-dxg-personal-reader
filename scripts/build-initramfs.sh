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
busybox=${BUSYBOX:-}
[ -x "$initramfs/init" ] || { echo "missing executable initramfs init: $initramfs/init" >&2; exit 1; }
[ -n "$busybox" ] && [ -f "$busybox" ] || {
  echo "missing static BusyBox: set BUSYBOX to an ARM BusyBox binary" >&2
  exit 1
}

if [ "$check_only" = true ]; then
  echo "initramfs prerequisites available: $busybox"
  exit 0
fi

out="$root/out/initramfs"
stage="$out/stage"
rm -rf "$stage"
mkdir -p "$stage/bin" "$stage/dev" "$stage/proc" "$stage/sys"
cp -R "$initramfs"/. "$stage"/
install -m 0755 "$busybox" "$stage/bin/busybox"
for applet in sh mount; do
  ln -sf busybox "$stage/bin/$applet"
done
(
  cd "$stage"
  find . -print | LC_ALL=C sort | cpio -o -H newc > "$out/dxg-diagnostic.cpio"
)
gzip -n -f "$out/dxg-diagnostic.cpio"
echo "Created $out/dxg-diagnostic.cpio.gz"
