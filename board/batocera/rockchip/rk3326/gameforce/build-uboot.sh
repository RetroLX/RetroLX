#!/bin/bash

HOST_DIR=$1
IMAGES_DIR=$2

# ARM Trusted Firmware BL31
export BL31="${IMAGES_DIR}/bl31.elf"

# Clone U-Boot mainline
wget "https://ftp.denx.de/pub/u-boot/u-boot-2021.07.tar.bz2"
tar xf u-boot-2021.07.tar.bz2
cd u-boot-2021.07

# Apply patches
PATCHES="${BOARD_DIR}/patches/uboot/*.patch"
for patch in $PATCHES
do
  echo "Applying patch: $patch"
  patch -p1 < $patch
done

# Make config
make odroid-go2_defconfig

# Build it
ARCH=aarch64 CROSS_COMPILE="${HOST_DIR}/bin/aarch64-buildroot-linux-gnu-" make -j$(nproc) all
mkdir -p ../../uboot-odroidgo2

# Copy to appropriate place
cp u-boot-rockchip.bin ../../uboot-odroidgo2/
#cp u-boot-dtb.img ../../uboot-odroidgo2/

# Generate Rockchip SPL image
#"${HOST_DIR}/bin/mkimage" -n px30 -T rksd -d "tpl/u-boot-tpl.bin" "../../uboot-odroidgo2/u-boot-tpl.img" || exit 1
#cat "spl/u-boot-spl-dtb.bin" >> "../../uboot-odroidgo2/u-boot-tpl.img" || exit 1
