#!/bin/bash

HOST_DIR=$1
BOARD_DIR=$2
IMAGES_DIR=$3

# ARM Trusted Firmware BL31
# export BL31="${IMAGES_DIR}/bl31.elf"

# Clone vendor U-Boot
git clone https://github.com/hardkernel/u-boot.git -b odroidgoA-v2017.09

# Clone vendor rkbin
git clone https://github.com/rockchip-linux/rkbin

# Enter directory
cd u-boot

# Apply patches
PATCHES="${BOARD_DIR}/patches/uboot/*.patch"
for patch in $PATCHES
do
  echo "Applying patch: $patch"
  patch -p1 < $patch
done

# Build it
./make.sh odroidgoa
mkdir -p ../../uboot-odroidgo

# Copy to appropriate place
cp sd_fuse/idbloader.img ../../uboot-odroidgo/
cp sd_fuse/uboot.img ../../uboot-odroidgo/
cp sd_fuse/trust.img ../../uboot-odroidgo/
