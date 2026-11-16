# Local-only build status

Date: 2026-11-16

## Completed host-side validation

- All five immutable input artifacts in `reference/` match `reference/ARTIFACTS.sha256`.
- `reference/linux-6.18.63.tar.xz` was extracted only below ignored `out/src/` and the generic i.MX ARMv4/v5 configuration was generated only below ignored `out/build-armv5/`.
- The provisional ARMv5 build configuration reports kernel release `6.18.63` and has SHA-256 `765ed66bbfbb9e4e71adc36012515724c577576cfca2e8e864c370ad671fa192`.
- The native macOS build reached host-tool compilation and stopped in Linux `scripts/sorttable.c` because the Darwin host does not provide `<elf.h>`. This is a Linux-host build dependency failure, not an ARM target or DXG hardware result.
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
| GNU Make 4.0 or newer | Available: Homebrew GNU Make 4.4.1 as `gmake` | The kernel build uses `gmake` by default. |
| 32-bit ARM cross compiler | Available: `arm-none-eabi-gcc` 16.2.0 | Suitable for the current kernel-only generic ARMv5 baseline. |
| Linux host build environment | Missing | Required because the Linux source builds host tools that include `<elf.h>`, absent on macOS. |
| Static ARM BusyBox | Not provided | Diagnostic initramfs packaging is blocked. |
| `mkimage` | Not installed intentionally | Not needed until the target U-Boot image format is proved. |
| Docker runtime | Available: 29.5.2 | Docker Buildx is unavailable, and no pinned Linux build image has been selected. |

## Physical-device blockers

No Kindle interaction occurred. The project has not jailedbroken, connected to, mounted, uploaded to, flashed, or otherwise altered a device. `hardware-blockers.md` lists the evidence required before physical bring-up can begin.

A complete local generic ARMv5 baseline build and external-module compile now require a pinned Linux-hosted build environment with the necessary Linux development headers, plus static ARM BusyBox for initramfs packaging. Selecting or downloading that environment is deferred until explicitly instructed. A successful result will still not prove DXG bootability.
