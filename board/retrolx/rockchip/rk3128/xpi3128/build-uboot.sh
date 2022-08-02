#!/bin/bash

HOST_DIR=$1
IMAGES_DIR=$2

# Clone U-Boot mainline
wget "https://ftp.denx.de/pub/u-boot/u-boot-2022.07.tar.bz2"
tar xf u-boot-2022.07.tar.bz2
cd u-boot-2022.07

# Apply patches
PATCHES="${BOARD_DIR}/patches/uboot/*.patch"
for patch in $PATCHES
do
  echo "Applying patch: $patch"
  patch -p1 < $patch
done

# Make config
make evb-rk3128_defconfig

# Build it
ARCH=arm CROSS_COMPILE="${HOST_DIR}/bin/arm-buildroot-linux-gnueabihf-" make -j$(nproc) all
mkdir -p ../../uboot-xpi3128

# Copy to appropriate place
cp u-boot-dtb.img ../../uboot-xpi3128/

# Generate Rockchip SPL image
"${HOST_DIR}/bin/mkimage" -n rk3128 -T rksd -d "tpl/u-boot-tpl.bin" "../../uboot-tinkerboard/u-boot-tpl.img" || exit 1
cat "spl/u-boot-spl-dtb.bin" >> "../../uboot-tinkerboard/u-boot-tpl.img" || exit 1
