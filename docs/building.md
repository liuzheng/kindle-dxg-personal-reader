# Local build prerequisites

The checked-in host is macOS and its GNU Make 3.81 cannot build Linux 6.18. Use an explicitly selected local 32-bit ARM Linux cross toolchain with GNU Make 4.0 or later. A future container is permitted only when the user supplies or approves a pinned image digest. Build scripts intentionally do not download tools or images.

## Required environment

```sh
export MAKE=gmake
export CROSS_COMPILE=arm-none-eabi-
export JOBS=2
./scripts/build-kernel.sh
```

The Homebrew `arm-none-eabi-gcc` toolchain is sufficient for the current kernel-only ARMv5 baseline. It is not used to build user-space binaries. Supply a separately pinned static ARM BusyBox before packaging the diagnostic initramfs.

The build begins from upstream `imx_v4_v5_defconfig` and applies `configs/dxg.config.fragment`. This output is a generic ARMv5/i.MX baseline. It must never be represented as a bootable DXG image until physical recovery and boot-chain evidence exists.

## Determinism

The kernel script sets deterministic Kbuild identity and timestamp variables. A future reproducibility run must use the same compiler revision and compare only selected outputs, such as `arch/arm/boot/zImage` and intended external modules.
