#!/usr/bin/env python3
"""Read Kindle update metadata without extracting, modifying, or packaging data."""

from __future__ import annotations

import argparse
import hashlib
import io
import struct
import sys
import tarfile
from pathlib import Path

OTA_HEADER_SIZE = 64
MANUAL_HEADER_SIZE = 131072
HEADER = struct.Struct("<4sIIHBx")
KNOWN_SIGNATURES = {b"FC02": "OTA", b"FD03": "OTA", b"FB01": "manual"}


def deobfuscate(data: bytes) -> bytes:
    return bytes((((value ^ 0x7A) >> 4) | (((value ^ 0x7A) << 4) & 0xFF)) for value in data)


def inspect(path: Path, list_members: bool) -> int:
    data = path.read_bytes()
    if len(data) < HEADER.size:
        print(f"{path}: truncated header", file=sys.stderr)
        return 1

    signature, minimum, maximum, device_code, optional = HEADER.unpack(data[: HEADER.size])
    kind = KNOWN_SIGNATURES.get(signature)
    if kind is None:
        print(f"{path}: unsupported signature {signature!r}", file=sys.stderr)
        return 1

    payload_offset = MANUAL_HEADER_SIZE if kind == "manual" else OTA_HEADER_SIZE
    if len(data) < payload_offset:
        print(f"{path}: truncated {kind} payload", file=sys.stderr)
        return 1

    payload = deobfuscate(data[payload_offset:])
    header_md5 = deobfuscate(data[HEADER.size : HEADER.size + 32]).decode("ascii", "replace")
    print(f"file: {path}")
    print(f"kind: {kind}")
    print(f"signature: {signature.decode('ascii')}")
    print(f"version-range: {minimum}..{maximum}")
    print(f"device-code: {device_code}")
    print(f"optional: {'yes' if optional else 'no'}")
    print(f"payload-bytes: {len(payload)}")
    print(f"payload-md5-header: {header_md5}")
    print(f"payload-md5-computed: {hashlib.md5(payload).hexdigest()}")

    if list_members:
        try:
            with tarfile.open(fileobj=io.BytesIO(payload), mode="r:gz") as archive:
                for member in archive.getmembers():
                    print(f"member: {member.name}")
        except (tarfile.TarError, OSError) as error:
            print(f"member-list: unavailable ({error})", file=sys.stderr)
            return 1
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--members", action="store_true", help="list gzip/tar members from decoded payloads")
    parser.add_argument("updates", metavar="UPDATE", nargs="+", type=Path)
    arguments = parser.parse_args()
    return max(inspect(path, arguments.members) for path in arguments.updates)


if __name__ == "__main__":
    raise SystemExit(main())
