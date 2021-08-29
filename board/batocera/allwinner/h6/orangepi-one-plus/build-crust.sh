#!/bin/bash

HOST_DIR=$1
BOARD_DIR=$2
IMAGES_DIR=$3

# Crust firmware version
export CRUST_VERSION="v0.4"

# Clone Crust specified version, copy board config
git clone --depth 1 https://github.com/crust-firmware/crust -b "${CRUST_VERSION}"
cp orangepi_one_plus_defconfig crust/configs
cd crust

# AArch64 toolchain
wget "https://musl.cc/aarch64-linux-musl-cross.tgz"
tar xzf aarch64-linux-musl-cross.tgz
export CROSS_aarch64="${IMAGES_DIR}/retrolx/crust/crust/aarch64-linux-musl-cross/bin/aarch64-linux-musl-"

# or1k toolchain
wget "https://musl.cc/or1k-linux-musl-cross.tgz"
tar xzf or1k-linux-musl-cross.tgz
export CROSS_or1k="${IMAGES_DIR}/retrolx/crust/crust/or1k-linux-musl-cross/bin/or1k-linux-musl-";

# Make config
make orangepi_one_plus_defconfig

# Build it
ARCH=aarch64 \
CROSS_COMPILE="${CROSS_or1k}" \
make -j$(nproc) scp
#mkdir -p ../../uboot-orangepi-one-plus

# Copy to appropriate place
#cp u-boot-sunxi-with-spl.bin ../../uboot-orangepi-one-plus/
