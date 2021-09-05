#!/bin/bash

HOST_DIR=$1
IMAGES_DIR=$2

# Clone U-Boot mainline
wget "https://ftp.denx.de/pub/u-boot/u-boot-2021.07.tar.bz2"
tar xf u-boot-2021.07.tar.bz2
cd u-boot-2021.07

# Make config
make orangepi_one_defconfig

# Build it
ARCH=arm CROSS_COMPILE="${HOST_DIR}/bin/arm-buildroot-linux-gnueabihf-" make -j$(nproc)
mkdir -p ../../uboot-orangepi-one

# Copy to appropriate place
cp u-boot-sunxi-with-spl.bin ../../uboot-orangepi-one/
