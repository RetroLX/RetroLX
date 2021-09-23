#!/bin/bash

HOST_DIR=$1
BOARD_DIR=$2
IMAGES_DIR=$3

# Clone U-Boot mainline
wget "https://ftp.denx.de/pub/u-boot/u-boot-2021.10-rc4.tar.bz2"
tar xf u-boot-2021.10-rc4.tar.bz2
cd u-boot-2021.10-rc4

# Apply patches
PATCHES="${BOARD_DIR}/patches/uboot/*.patch"
for patch in $PATCHES
do
  echo "Applying patch: $patch"
  patch -p1 < $patch
done

# Make config
make evb-rk3568_defconfig

# Build it
ARCH=aarch64 CROSS_COMPILE="${HOST_DIR}/bin/aarch64-buildroot-linux-gnu-" make -j$(nproc)
mkdir -p ../../uboot-rk3568

# Rockchip process
git clone https://github.com/rockchip-linux/rkbin.git
cd rkbin
./tools/trust_merger ./RKTRUST/RK3568TRUST.ini
./tools/loaderimage --pack --uboot ../u-boot-dtb.bin uboot.img
cd ..

# Copy generated files
cp "rkbin/trust.img" "../trust.img"
cp "rkbin/uboot.img" "../uboot.img"
