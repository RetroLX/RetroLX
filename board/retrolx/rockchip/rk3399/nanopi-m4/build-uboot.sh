#!/bin/bash

HOST_DIR=$1
BOARD_DIR=$2
IMAGES_DIR=$3

# ARM Trusted Firmware BL31
export BL31="${IMAGES_DIR}/atf/rk3399/bl31.elf"

# Clone Rockchip U-Boot
git clone --depth 1 https://github.com/rockchip-linux/u-boot/ -b next-dev
cd u-boot

# Clone mrfixit2001 U-Boot Builder
git clone --depth 1 https://github.com/mrfixit2001/uboot_builder

# Apply patches
PATCHES="${BOARD_DIR}/patches/uboot/*.patch"
for patch in $PATCHES
do
  echo "Applying patch: $patch"
  patch -p1 < $patch
done

# Build U-Boot
ARCH=aarch64 CROSS_COMPILE="${HOST_DIR}/bin/aarch64-buildroot-linux-gnu-" make -j$(nproc) mrproper evb-rk3399_defconfig all

# Rockchip process
cp u-boot-dtb.bin ./uboot_builder/rk3399
cd uboot_builder/rk3399
./make-uboot.sh

# Copy to appropriate place
mkdir -p ../../../../uboot-evb-rk3399
mv *.img ../../../../uboot-evb-rk3399
