#!/bin/bash

# ARM Trusted Firmware BL31
export BL31="/h5/images/bl31.bin"
# Crust firmware (optional)
export SCP="/dev/null"

# Clone U-Boot mainline
git clone --depth 1 https://source.denx.de/u-boot/u-boot.git -b v2021.07
cd u-boot

# Make config
make libretech_all_h3_cc_h5_defconfig

# Build it
ARCH=aarch64 CROSS_COMPILE=/h5/host/bin/aarch64-buildroot-linux-gnu- make -j$(nproc)
mkdir -p ../../uboot-tritium-h5

# Copy to appropriate place
cp u-boot-sunxi-with-spl.bin ../../uboot-tritium-h5/
