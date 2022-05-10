#!/bin/bash

HOST_DIR=$1
IMAGES_DIR=$2

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
make miqi-rk3288_defconfig

# Build it
ARCH=arm CROSS_COMPILE="${HOST_DIR}/bin/arm-buildroot-linux-gnueabihf-" make -j$(nproc) all
mkdir -p ../../uboot-miqi

# Copy to appropriate place
cp u-boot-dtb.img ../../uboot-miqi/

# Generate Rockchip SPL image
"${HOST_DIR}/bin/mkimage" -n rk3288 -T rksd -d "spl/u-boot-spl-dtb.bin" "../../uboot-miqi/u-boot-tpl.img" || exit 1
cat "u-boot-dtb.bin" >> "../../uboot-miqi/u-boot-tpl.img" || exit 1
