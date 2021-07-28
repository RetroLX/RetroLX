#!/bin/bash

git clone --depth 1 https://source.denx.de/u-boot/u-boot.git -b v2021.07
cd u-boot
ARCH=arm CROSS_COMPILE=/rk3288/host/bin/arm-buildroot-linux-gnueabihf- make -j$(nproc) tinker-rk3288_defconfig all
mkdir -p ../../uboot-tinkerboard
cp u-boot-dtb.img ../../uboot-tinkerboard/
"/rk3288/host/bin/mkimage" -n rk3288 -T rksd -d "tpl/u-boot-tpl.bin" "../../uboot-tinkerboard/u-boot-tpl.img" || exit 1
cat "spl/u-boot-spl-dtb.bin" >> "../../uboot-tinkerboard/u-boot-tpl.img" || exit 1

