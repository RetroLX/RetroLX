#!/bin/bash

HOST_DIR=$1
BOARD_DIR=$2
IMAGES_DIR=$3

# ARM Trusted Firmware BL31
#export BL31="${IMAGES_DIR}/bl31.bin"

# Crust firmware (optional)
#export SCP="/dev/null"

# Crust firmware version
export CRUST_VERSION="v0.4"

# Clone U-Boot specified version
git clone --depth 1 https://github.com/crust-firmware/crust -b "${CRUST_VERSION}"
cp orangepi_one_plus_defconfig crust/configs
cd crust

# AArch64 toolchain
wget "https://musl.cc/aarch64-linux-musl-cross.tgz"
tar xjf aarch64-linux-musl-cross.tgz

# OR1k toolchain
wget "https://musl.cc/or1k-linux-musl-cross.tgz"
tar xzvf or1k-linux-musl-cross.tgz

# Make config
make orangepi_one_plus_defconfig

# Build it
ARCH=aarch64 \
CROSS_aarch64="${IMAGES_DIR}/retrolx/crust/crust/aarch64-linux-musl-cross/aarch64-linux-musl-" \
CROSS_or1k="${IMAGES_DIR}/retrolx/crust/crust/or1k-linux-musl-cross/or1k-linux-musl-" \
CROSS_COMPILE="${IMAGES_DIR}/retrolx/crust/crust/or1k-linux-musl-cross/or1k-linux-musl-" \
make -j$(nproc) scp
#mkdir -p ../../uboot-orangepi-one-plus

# Copy to appropriate place
#cp u-boot-sunxi-with-spl.bin ../../uboot-orangepi-one-plus/
