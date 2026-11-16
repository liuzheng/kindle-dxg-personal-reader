# Kindle DX Graphite local porting project

This repository prepares a Linux 6.18.63 porting project for an original Kindle DX Graphite (B009). The current scope is **local only**. It may inspect artifacts already in this repository and create generated files below `out/`; it must not connect to, jailbreak, mount, upload to, flash, or otherwise alter a Kindle.

## Current boundary

- Target kernel source: `reference/linux-6.18.63.tar.xz`.
- Target CPU family evidence: i.MX31-class ARMv5, inferred from supplied firmware. It is not a complete board identification.
- Display evidence: ED097OC1(LF) 34-pin E-Ink panel. No display driver is implemented yet.
- Wireless work is Phase 2 and is not part of the local build path.
- The historical Kindle update tool is reference-only. Do not use it to create an update or recovery package.

## Project layout

- `configs/`: provisional, evidence-limited kernel configuration fragments.
- `docs/`: source provenance, driver boundaries, and deferred hardware gates.
- `modules/dxg_legacy/`: external-module build scaffold, not a hardware driver.
- `patches/`: ordered future patch list. It is empty until source provenance is verified.
- `rootfs/initramfs/`: source layout for a diagnostic initramfs.
- `scripts/`: host-only inspection, prerequisite, native preflight, container-build, and manifest tools.
- `container/`: pinned Linux kernel-build environment definition.
- `out/`: ignored extracted sources, build products, images, and logs.

## Local validation

```sh
./scripts/check-host.sh
./scripts/inspect-kindle-update.py reference/Update_kindle_2.5.8_B009.bin reference/update-caupdate-09.bin
./scripts/check-patch-series.sh patches/series
./scripts/build-kernel.sh --check
./scripts/build-initramfs.sh --check
./scripts/package-image-manifest.sh --check
```

`check-host.sh` is expected to report missing prerequisites on a machine without GNU Make 4+ and an ARM Linux cross compiler. No script downloads toolchains or containers.

## Later device work

Only after explicit authorization may a future phase jailbreak or interact with the DXG. That phase must first satisfy the recovery, backup, serial/debug, and reversible-boot gates in `openspec/changes/assess-dxg-modernization/`.
