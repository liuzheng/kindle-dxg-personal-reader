#!/bin/sh
# Check patch-series layout only; does not apply any patch.
set -eu

series=${1:-patches/series}
[ -f "$series" ] || { echo "missing series file: $series" >&2; exit 1; }

status=0
while IFS= read -r patch || [ -n "$patch" ]; do
  case "$patch" in
    ''|'#'*) continue ;;
  esac
  if [ -f "$(dirname "$series")/$patch" ]; then
    printf 'ok: patch %s\n' "$patch"
  else
    printf 'missing: patch %s\n' "$patch" >&2
    status=1
  fi
done < "$series"

exit "$status"
