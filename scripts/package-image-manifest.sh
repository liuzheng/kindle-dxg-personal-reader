#!/bin/sh
# Write a local image-input manifest. No Kindle update archive is ever produced.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
check_only=false
if [ "${1:-}" = "--check" ]; then
  check_only=true
elif [ "$#" -ne 0 ]; then
  echo "usage: $0 [--check]" >&2
  exit 64
fi

required="reference/linux-6.18.63.tar.xz configs/dxg.config.fragment modules/dxg_legacy/Makefile rootfs/initramfs/init patches/series"
for path in $required; do
  [ -f "$root/$path" ] || { echo "missing required input: $path" >&2; exit 1; }
done

if [ "$check_only" = true ]; then
  echo "image-manifest inputs are present; no image was created"
  exit 0
fi

out="$root/out/manifests"
mkdir -p "$out"
{
  echo '# Local input manifest. This is not a Kindle update package.'
  echo "generated-utc: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  (cd "$root" && shasum -a 256 $required)
} > "$out/dxg-local-image-inputs.sha256"
echo "Created $out/dxg-local-image-inputs.sha256"
