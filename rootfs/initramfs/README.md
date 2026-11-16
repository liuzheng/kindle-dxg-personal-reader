# Diagnostic initramfs source

This directory is a source layout, not a complete initramfs. `scripts/build-initramfs.sh` requires a separate static ARM BusyBox path through `BUSYBOX`; it copies that binary and the required `sh` and `mount` applet links into an ignored staging directory below `out/` before packaging.

The approved Linux build image provides Debian `busybox-static:armel` for local packaging. It is a static 32-bit ARM binary and is never run on the ARM64 build container.

`init` only mounts proc, sysfs, and devtmpfs, prints a safety banner, and opens a shell. It has no Kindle-specific device setup and no deployment path.

Build locally after the cross toolchain is available:

```sh
BUSYBOX=/absolute/path/to/arm-busybox ./scripts/build-initramfs.sh
```
