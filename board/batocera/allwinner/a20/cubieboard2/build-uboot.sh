#!/bin/bash

HOST_DIR=$1
IMAGES_DIR=$2

# Clone U-Boot mainline
git clone --depth 1 https://source.denx.de/u-boot/u-boot.git -b v2021.07
cd u-boot

# Make config
make Cubieboard2_defconfig

# Build it
ARCH=arm CROSS_COMPILE="${HOST_DIR}/bin/arm-buildroot-linux-gnueabihf-" make -j$(nproc)
mkdir -p ../../uboot-cubieboard2

# Copy to appropriate place
cp u-boot-sunxi-with-spl.bin ../../uboot-cubieboard2/
