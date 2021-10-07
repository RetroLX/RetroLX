#!/bin/bash

HOST_DIR=$1
IMAGES_DIR=$2

# ARM Trusted Firmware BL31
export BL31="${IMAGES_DIR}/bl31.bin"
# Crust firmware (optional)
export SCP="/dev/null"

# Clone U-Boot mainline
wget "https://ftp.denx.de/pub/u-boot/u-boot-2021.10.tar.bz2"
tar xf u-boot-2021.10.tar.bz2
cd u-boot-2021.10

# Apply patches
PATCHES="${BOARD_DIR}/patches/uboot/*.patch"
for patch in $PATCHES
do
  echo "Applying patch: $patch"
  patch -p1 < $patch
done

# Make config
make libretech_all_h3_cc_h5_defconfig

# Build it
ARCH=aarch64 CROSS_COMPILE="${HOST_DIR}/bin/aarch64-buildroot-linux-gnu-" make -j$(nproc)
mkdir -p ../../uboot-tritium-h5

# Copy to appropriate place
cp u-boot-sunxi-with-spl.bin ../../uboot-tritium-h5/
