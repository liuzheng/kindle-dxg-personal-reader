# Diagnostic initramfs source

This directory is a source layout, not a complete initramfs. To build it, provide an approved **static ARM BusyBox** at `rootfs/initramfs/bin/busybox`, or set `BUSYBOX` to its path.

`init` only mounts proc, sysfs, and devtmpfs, prints a safety banner, and opens a shell. It has no Kindle-specific device setup and no deployment path.

Build locally after the cross toolchain is available:

```sh
BUSYBOX=/absolute/path/to/arm-busybox ./scripts/build-initramfs.sh
```
