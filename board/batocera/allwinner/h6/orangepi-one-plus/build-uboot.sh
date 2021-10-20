#!/bin/bash

HOST_DIR=$1
BOARD_DIR=$2
IMAGES_DIR=$3

# ARM Trusted Firmware BL31
export BL31="${IMAGES_DIR}/bl31.bin"

# Crust firmware (optional)
export SCP="/dev/null"

# U-Boot version
export UBOOT_VERSION="v2021.01"
#not working so far export UBOOT_VERSION="v2021.10"

# Clone U-Boot specified version
git clone --depth 1 https://source.denx.de/u-boot/u-boot.git -b "${UBOOT_VERSION}"
cd u-boot

# Apply patches
PATCHES="${BOARD_DIR}/patches/uboot/*.patch"
for patch in $PATCHES
do
  echo "Applying patch: $patch"
  patch -p1 < $patch
done

# Make config
make orangepi_one_plus_defconfig

# Build it
ARCH=aarch64 CROSS_COMPILE="${HOST_DIR}/bin/aarch64-buildroot-linux-gnu-" make -j$(nproc)
mkdir -p ../../uboot-orangepi-one-plus

# Copy to appropriate place
cp u-boot-sunxi-with-spl.bin ../../uboot-orangepi-one-plus/
