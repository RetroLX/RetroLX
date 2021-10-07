#!/bin/bash

HOST_DIR=$1
BOARD_DIR=$2
IMAGES_DIR=$3

# ARM Trusted Firmware BL31
export BL31="${IMAGES_DIR}/bl31.elf"

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
make roc-cc-rk3328_defconfig

# Build it
ARCH=aarch64 CROSS_COMPILE="${HOST_DIR}/bin/aarch64-buildroot-linux-gnu-" make -j$(nproc) all
mkdir -p ../../uboot-roc-cc

# Copy to appropriate place
cp u-boot-rockchip.bin ../../uboot-roc-cc/
#cp u-boot-dtb.img ../../uboot-roc-cc/

# Generate Rockchip SPL image
#"${HOST_DIR}/bin/mkimage" -n px30 -T rksd -d "tpl/u-boot-tpl.bin" "../../uboot-roc-cc/u-boot-tpl.img" || exit 1
#cat "spl/u-boot-spl-dtb.bin" >> "../../uboot-roc-cc/u-boot-tpl.img" || exit 1
