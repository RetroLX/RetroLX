#!/bin/bash

HOST_DIR=$1
BOARD_DIR=$2
BINARIES_DIR=$3
PLATFORM=$4

# Define ATF version
ATF_VERSION="2.5"

# Download and extract ATF
wget "https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git/snapshot/trusted-firmware-a-${ATF_VERSION}.tar.gz"
tar xzvf "trusted-firmware-a-${ATF_VERSION}.tar.gz"
cd "trusted-firmware-a-${ATF_VERSION}"

# Apply patches
PATCHES="${BOARD_DIR}/../patches/atf/*.patch"
for patch in $PATCHES
do
  echo "Applying patch: $patch"
  patch -p1 < $patch
done

# Build ATF
CROSS_COMPILE="${HOST_DIR}/bin/aarch64-buildroot-linux-gnu-" make PLAT="${PLATFORM}" -j$(nproc)

# Copy to appropriate place
mkdir -p "${BINARIES_DIR}/atf/${PLATFORM}"
cp "build/${PLATFORM}/bl31.bin" "${BINARIES_DIR}/atf/${PLATFORM}/bl31.bin"
cp "build/${PLATFORM}/bl31/bl31.elf" "${BINARIES_DIR}/atf/${PLATFORM}/bl31.elf"
