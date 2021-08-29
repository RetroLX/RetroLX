#!/bin/bash

HOST_DIR=$1
IMAGES_DIR=$2

# Clone U-Boot mainline
git clone --depth 1 https://source.denx.de/u-boot/u-boot.git -b v2021.07
cd u-boot

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
