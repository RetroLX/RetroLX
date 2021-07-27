#!/bin/bash

git clone --depth 1 https://source.denx.de/u-boot/u-boot.git -b v2019.04
cd u-boot
make tinker-rk3288_defconfig
ARCH=arm CROSS_COMPILE=/h3/host/bin/arm-buildroot-linux-gnueabihf- make -j$(nproc)
mkdir -p ../../uboot-tinkerboard
cp u-boot-sunxi-with-spl.bin ../../uboot-tinkerboard/
"${HOST_DIR}/bin/mkimage" -n rk3288 -T rksd -d "${BINARIES_DIR}/tinkerboard/u-boot-spl-dtb.bin" "${BINARIES_DIR}/tinkerboard/u-boot-spl-dtb.img" || exit 1
cat "$BINARIES_DIR/tinkerboard/u-boot-dtb.bin" >> "${BINARIES_DIR}/tinkerboard/u-boot-spl-dtb.img" || exit 1

