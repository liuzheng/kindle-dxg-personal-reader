# Local-only phase boundary

This phase creates and validates host-side files only. It does not authorize device access.

## Permitted

- Read supplied archives and documents from this repository.
- Extract Linux source only below ignored `out/src/`.
- Build only below ignored `out/` when an explicitly selected local toolchain is available.
- Inspect Kindle update headers and gzip/tar member names in memory.

## Prohibited

- Jailbreaking, USB mounting, SSH/USBNetwork access, update-package creation, device upload, bootloader changes, MTD reads/writes, or hardware changes.
- Treating generic i.MX builds, QEMU results, or module compilation as DXG hardware proof.

## Deferred facts

The physical-device phase must establish board revision, serial/debug path, memory and MTD map, bootloader environment, E-Ink controller, input, power-management IC, USB role wiring, and recoverable non-persistent boot mechanism.
