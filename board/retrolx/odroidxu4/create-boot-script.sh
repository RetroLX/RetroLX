#!/bin/bash

# HOST_DIR = host dir
# BOARD_DIR = board specific dir
# BUILD_DIR = base dir/build
# BINARIES_DIR = images dir
# TARGET_DIR = target dir
# RETROLX_BINARIES_DIR = RetroLX binaries sub directory

HOST_DIR=$1
BOARD_DIR=$2
BUILD_DIR=$3
BINARIES_DIR=$4
TARGET_DIR=$5
RETROLX_BINARIES_DIR=$6

mkdir -p "${RETROLX_BINARIES_DIR}/boot/packages" || exit 1
cat "${BUILD_DIR}/board/retrolx/packages.txt" "${BUILD_DIR}/board/retrolx/odroidxu4/packages.txt" > "${RETROLX_BINARIES_DIR}/boot/packages.txt"
cat "${RETROLX_BINARIES_DIR}/boot/packages.txt" | while read line; do cp "${BUILD_DIR}/repo/${line}"* "${RETROLX_BINARIES_DIR}/boot/packages/"; done

mkdir -p "${RETROLX_BINARIES_DIR}/boot/boot"     || exit 1
mkdir -p "${RETROLX_BINARIES_DIR}/boot/extlinux" || exit 1

cp "${BOARD_DIR}/boot/boot-logo.bmp.gz"       "${RETROLX_BINARIES_DIR}/boot/"             || exit 1
cp "${BOARD_DIR}/boot/extlinux.conf"          "${RETROLX_BINARIES_DIR}/boot/extlinux/"    || exit 1
cp "${BINARIES_DIR}/exynos5422-odroidxu4.dtb" "${RETROLX_BINARIES_DIR}/boot/boot/"        || exit 1
cp "${BINARIES_DIR}/modules"                  "${RETROLX_BINARIES_DIR}/boot/boot/modules" || exit 1

cp "${BINARIES_DIR}/zImage"          "${RETROLX_BINARIES_DIR}/boot/boot/linux"           || exit 1
cp "${BINARIES_DIR}/initrd.gz"       "${RETROLX_BINARIES_DIR}/boot/boot/initrd.gz"       || exit 1
cp "${BINARIES_DIR}/rootfs.squashfs" "${RETROLX_BINARIES_DIR}/boot/boot/retrolx.update" || exit 1

# because otherwise tzw overlapse
dd if="${BINARIES_DIR}/u-boot.bin" of="${BINARIES_DIR}/u-boot.bin.reduced" bs=512 count=1440

exit 0
