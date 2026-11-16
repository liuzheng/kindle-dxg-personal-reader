# Local-only build status

Date: 2026-11-16

## Completed host-side validation

- All five immutable input artifacts in `reference/` match `reference/ARTIFACTS.sha256`.
- `reference/linux-6.18.63.tar.xz` was extracted only below ignored `out/src/` and the generic i.MX ARMv4/v5 configuration was generated only below ignored `out/build-armv5/`.
- A Linux-hosted container build completed for the generic i.MX ARMv5 baseline with `zImage`, `vmlinux`, 14 DTBs, and the configured in-tree modules. This is a generic upstream build, not a DXG boot image.
- The external no-hardware compatibility-module scaffold compiled successfully as `modules/dxg_legacy/dxg_legacy_stub.ko` against the same configured build tree.
- The diagnostic initramfs packaged successfully at `out/initramfs/dxg-diagnostic.cpio.gz` using Debian `busybox-static:armel` 1:1.35.0-4+deb12u1+b1. Its CPIO manifest contains `init`, static `bin/busybox`, and `bin/sh`/`bin/mount` applet links with `dev`, `proc`, and `sys` mount points.
- Build outputs have these SHA-256 values:

  ```text
  49ac5c1cca9dea5fa33b2a1ece6e64f89c43da74caf0b0aabbc1a783a933247a  arch/arm/boot/zImage
  e0104fe0f170ab18f4be043569d44a9839b37b2f54e0224bf09a8ba25071f601  vmlinux
  aad6710f2b9d3c24da4df927a976f106f864d3da317d7462181ea47c6092f74e  dxg_legacy_stub.ko
  fbdef1ff25a6636c0ede4eb49fe7124f4fd0e7ad3622bdcbd15823f73cc4ed00  dxg-diagnostic.cpio.gz
  03c6783563893b6690d230ec085d56618aeaaed150358f1dbcba4ff87a720094  .config
  ```

- `vmlinux` is a 32-bit little-endian ARM ELF executable with ARM EABI version 5 and soft-float ABI. The scaffold module is a 32-bit ARM EABI relocatable ELF object.
- The Linux build container image is `dxg-linux-build:bookworm-20261116`, image ID `sha256:94793e414a07ad8a915a6641ded3549d87e7f3eb2234e38f3a6bb993f9b7aeef`.
- The Python 3 update inspector validated both supplied FC02 DXG packages as device code 9 and validated their decoded payload MD5 values.
- Member listing succeeded in memory for `update-caupdate-09.bin`; no payload was written to the workspace.
- Shell syntax validation passed for every host-only script and the initramfs entry point.
- `configs/dxg.config.fragment` is explicitly marked provisional and not a verified DXG configuration.
- `scripts/check-patch-series.sh` accepts the intentionally empty patch series.
- `scripts/package-image-manifest.sh --check` confirms its source inputs without producing a deployable image.
- The module and initramfs builders reject missing prerequisite inputs with clear errors.

## Current host prerequisites

| Requirement | Result | Effect |
| --- | --- | --- |
| GNU Make 4.0 or newer | Available: Homebrew GNU Make 4.4.1 as `gmake` | Enables local configuration checks. |
| 32-bit ARM cross compiler | Available: `arm-none-eabi-gcc` 16.2.0 | Enables local preflight only. |
| Linux host build environment | Available: `dxg-linux-build:bookworm-20261116` | Completed generic kernel and external-module build using `arm-linux-gnueabi-gcc` 12.2.0. |
| Static ARM BusyBox | Available inside the pinned Linux build image: Debian `busybox-static:armel` 1:1.35.0-4+deb12u1+b1 | Packaged diagnostic initramfs successfully. |
| `mkimage` | Not installed intentionally | Not needed until the target U-Boot image format is proved. |
| Docker runtime | Available: 29.5.2 | Buildx is unavailable, but the legacy builder built the pinned-base image successfully. |

## Reproducibility record

The container base is pinned to `debian@sha256:3783cc01769c7b2b1b83a5c5ad96c815348e28ed7da68e2e3687004faa906251`. The resulting image ID is recorded above. Installed critical package versions were `make=4.3-4.1`, `gcc-arm-linux-gnueabi=4:12.2.0-3`, `libelf-dev=0.188-2.1`, `libssl-dev=3.0.22-1~deb12u2`, `pahole=1.24-4.1`, and `busybox-static:armel=1:1.35.0-4+deb12u1+b1`. The base image is immutable; package installation remains tied to the Debian repository state at image-build time. A future production-quality build must pin an APT snapshot or export the completed image by digest.

## Physical-device blockers

No Kindle interaction occurred. The project has not jailedbroken, connected to, mounted, uploaded to, flashed, or otherwise altered a device. `hardware-blockers.md` lists the evidence required before physical bring-up can begin.

The local-only build phase is complete. Its remaining limits are the device-specific hardware evidence and recovery gates in `hardware-blockers.md`. None of these host-side successes prove DXG bootability.
