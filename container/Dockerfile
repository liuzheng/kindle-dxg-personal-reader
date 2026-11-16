# Pinned local Debian Bookworm base image; see docs/building.md for its digest record.
FROM debian@sha256:3783cc01769c7b2b1b83a5c5ad96c815348e28ed7da68e2e3687004faa906251

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
      bc \
      bison \
      build-essential \
      cpio \
      device-tree-compiler \
      flex \
      gcc-arm-linux-gnueabi \
      libelf-dev \
      libssl-dev \
      pahole \
      python3 \
      rsync \
      xz-utils \
 && rm -rf /var/lib/apt/lists/*

# `busybox-static:armel` is a static 32-bit ARM EABI diagnostic-shell input.
# It is installed only for packaging; it is never executed by this ARM64 container.
RUN dpkg --add-architecture armel \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes busybox-static:armel \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
