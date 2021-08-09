#!/bin/bash

git clone --depth 1 https://source.denx.de/u-boot/u-boot.git -b v2021.07
cd u-boot
make libretech_all_h3_cc_h5_defconfig
ARCH=aarch64 CROSS_COMPILE=/h5/host/aarch64-buildroot-linux-gnu- make -j$(nproc)
mkdir -p ../../uboot-tritium-h5
cp u-boot-sunxi-with-spl.bin ../../uboot-tritium-h5/
