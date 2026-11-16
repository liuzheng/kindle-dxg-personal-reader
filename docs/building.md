# Local build prerequisites

The checked-in macOS host uses Homebrew GNU Make and the ARM bare-metal toolchain for initial configuration checks. Linux host tools in Linux 6.18 require a Linux build environment, so complete builds use the pinned Debian Bookworm container defined in `container/Dockerfile`. Its base image is pinned to `debian@sha256:3783cc01769c7b2b1b83a5c5ad96c815348e28ed7da68e2e3687004faa906251`. Build scripts intentionally do not download tools or images; the container Dockerfile installs its declared Debian packages only when explicitly built.

## Required environment

```sh
export MAKE=gmake
export CROSS_COMPILE=arm-none-eabi-
export JOBS=2
./scripts/build-kernel.sh
```

The Homebrew `arm-none-eabi-gcc` toolchain is sufficient for the current kernel-only ARMv5 baseline. It is not used to build user-space binaries. Supply a separately pinned static ARM BusyBox before packaging the diagnostic initramfs.

The build begins from upstream `imx_v4_v5_defconfig` and applies `configs/dxg.config.fragment`. This output is a generic ARMv5/i.MX baseline. It must never be represented as a bootable DXG image until physical recovery and boot-chain evidence exists.

## Linux container build

Build the approved local image, then run the generic baseline build:

```sh
./scripts/build-kernel-container.sh image
JOBS=2 ./scripts/build-kernel-container.sh build
./scripts/build-module-container.sh
./scripts/build-initramfs-container.sh
```

The image contains GNU Make, `gcc-arm-linux-gnueabi`, Linux host ELF headers, and the kernel build tools declared in `container/Dockerfile`. It writes extracted sources and outputs only to `out/` through the mounted workspace. The image and build output are local artifacts; neither command accesses a Kindle.

## Determinism

The kernel script sets deterministic Kbuild identity and timestamp variables. A future reproducibility run must use the same compiler revision and compare only selected outputs, such as `arch/arm/boot/zImage` and intended external modules.
