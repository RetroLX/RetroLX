#!/bin/bash

HOST_DIR=$1
BOARD_DIR=$2
IMAGES_DIR=$3

# ARM Trusted Firmware BL31
export BL31="${IMAGES_DIR}/atf/sun50i_a64/bl31.bin"

# Crust firmware (optional)
export SCP="/dev/null"

# Clone U-Boot mainline
wget "https://ftp.denx.de/pub/u-boot/u-boot-2022.04.tar.bz2"
tar xf u-boot-2022.04.tar.bz2
cd u-boot-2022.04

# Apply patches
PATCHES="${BOARD_DIR}/patches/uboot/*.patch"
for patch in $PATCHES
do
  echo "Applying patch: $patch"
  patch -p1 < $patch
done

# Make config
make orangepi_pc2_defconfig

# Build it
ARCH=aarch64 CROSS_COMPILE="${HOST_DIR}/bin/aarch64-buildroot-linux-gnu-" make -j$(nproc)
mkdir -p ../../uboot-orangepi-pc2

# Copy to appropriate place
cp u-boot-sunxi-with-spl.bin ../../uboot-orangepi-pc2/
