#!/bin/bash

HOST_DIR=$1
BOARD_DIR=$2
IMAGES_DIR=$3

# ARM Trusted Firmware BL31
# export BL31="${IMAGES_DIR}/bl31.elf"

# Clone custom U-Boot
git clone https://github.com/tonyjih/RG351-u-boot

# Clone vendor rkbin
git clone https://github.com/rockchip-linux/rkbin

# Enter directory
cd RG351-u-boot

# Apply patches
PATCHES="${BOARD_DIR}/patches/uboot/*.patch"
for patch in $PATCHES
do
  echo "Applying patch: $patch"
  patch -p1 < $patch
done

# Built it
./make.sh odroidgoa
#ARCH=aarch64 CROSS_COMPILE="${HOST_DIR}/bin/aarch64-buildroot-linux-gnu-" make -j$(nproc) all
mkdir -p ../../uboot-rg351

# Copy to appropriate place
cp arch/arm/dts/rg351*.dtb ../../uboot-rg351/
cp sd_fuse/idbloader.img ../../uboot-rg351/
cp sd_fuse/uboot.img ../../uboot-rg351/
cp sd_fuse/trust.img ../../uboot-rg351/
