#!/bin/sh
# Report host prerequisites. This script does not download software or touch devices.
set -eu

report_only=false
if [ "${1:-}" = "--report-only" ]; then
  report_only=true
elif [ "$#" -ne 0 ]; then
  echo "usage: $0 [--report-only]" >&2
  exit 64
fi

missing=0
require_command() {
  if command -v "$1" >/dev/null 2>&1; then
    printf 'ok: %s = %s\n' "$1" "$(command -v "$1")"
  else
    printf 'missing: %s\n' "$1" >&2
    missing=1
  fi
}

require_command python3
require_command xz
require_command tar
require_command dtc
require_command cpio

make_bin=${MAKE:-gmake}
if command -v "$make_bin" >/dev/null 2>&1; then
  make_version=$("$make_bin" --version 2>/dev/null | awk 'NR == 1 { print $3 }')
else
  make_version=
  missing=1
  printf 'missing: GNU Make command %s (set MAKE for an approved GNU Make >= 4.0)\n' "$make_bin" >&2
fi
make_major=$(printf '%s\n' "$make_version" | awk -F. 'NR == 1 { print $1 }')
if [ -n "$make_major" ] && [ "$make_major" -ge 4 ] 2>/dev/null; then
  printf 'ok: GNU Make %s (%s)\n' "$make_version" "$(command -v "$make_bin")"
else
  printf 'missing: GNU Make >= 4.0 (found %s)\n' "${make_version:-unavailable}" >&2
  missing=1
fi

cross_prefix=${CROSS_COMPILE:-arm-none-eabi-}
if command -v "${cross_prefix}gcc" >/dev/null 2>&1; then
  printf 'ok: cross-compiler = %s\n' "$(command -v "${cross_prefix}gcc")"
else
  printf 'missing: %sgcc (set CROSS_COMPILE for an approved local toolchain)\n' "$cross_prefix" >&2
  missing=1
fi

if command -v mkimage >/dev/null 2>&1; then
  printf 'optional: mkimage = %s\n' "$(command -v mkimage)"
else
  printf 'optional-missing: mkimage (do not install until the target U-Boot format is proven)\n' >&2
fi

if [ "$report_only" = true ]; then
  exit 0
fi
exit "$missing"
