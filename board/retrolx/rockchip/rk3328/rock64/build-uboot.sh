#!/bin/bash

HOST_DIR=$1
BOARD_DIR=$2
IMAGES_DIR=$3

# ARM Trusted Firmware BL31
export BL31="${IMAGES_DIR}/atf/rk3328/bl31.elf"

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
make rock64-rk3328_defconfig

# Build it
ARCH=aarch64 CROSS_COMPILE="${HOST_DIR}/bin/aarch64-buildroot-linux-gnu-" make -j$(nproc) all
mkdir -p ../../uboot-rock64

# Copy to appropriate place
cp u-boot-rockchip.bin ../../uboot-rock64/
#cp u-boot-dtb.img ../../uboot-rock64/

# Generate Rockchip SPL image
#"${HOST_DIR}/bin/mkimage" -n px30 -T rksd -d "tpl/u-boot-tpl.bin" "../../uboot-rock64/u-boot-tpl.img" || exit 1
#cat "spl/u-boot-spl-dtb.bin" >> "../../uboot-rock64/u-boot-tpl.img" || exit 1
