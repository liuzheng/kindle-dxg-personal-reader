# DXG legacy external-module scaffold

`dxg_legacy_stub` is intentionally a no-hardware module. It verifies the external-module boundary without importing proprietary or unverified legacy code.

Build only with a configured Linux 6.18 build tree:

```sh
make -C modules/dxg_legacy \
  KSRC="$PWD/out/src/linux-6.18.63" \
  KDIR="$PWD/out/build-armv5"
```

Do not add display, input, power, storage, USB, or wireless support here until `docs/driver-boundaries.md` has been updated with its source provenance, SPDX/license status, Linux 6.18 porting notes, and physical-device smoke test.
