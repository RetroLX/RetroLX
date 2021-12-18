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
cat "${BUILD_DIR}/board/retrolx/packages.txt" "${BUILD_DIR}/board/retrolx/raspberrypi/rpi3/packages.txt" > "${RETROLX_BINARIES_DIR}/boot/packages.txt"
cat "${RETROLX_BINARIES_DIR}/boot/packages.txt" | while read line; do cp "${BUILD_DIR}/repo/${line}"* "${RETROLX_BINARIES_DIR}/boot/packages/"; done

mkdir -p "${RETROLX_BINARIES_DIR}/boot/boot" || exit 1

cp -pr "${BINARIES_DIR}/rpi-firmware/"* "${RETROLX_BINARIES_DIR}/boot/" || exit 1
cp -f  "${BINARIES_DIR}/"*.dtb          "${RETROLX_BINARIES_DIR}/boot/" || exit 1
cp     "${BOARD_DIR}/boot/config.txt"   "${RETROLX_BINARIES_DIR}/boot/" || exit 1
cp     "${BOARD_DIR}/boot/cmdline.txt"  "${RETROLX_BINARIES_DIR}/boot/" || exit 1

cp "${BINARIES_DIR}/Image"           "${RETROLX_BINARIES_DIR}/boot/boot/linux"           || exit 1
cp "${BINARIES_DIR}/initrd.gz"       "${RETROLX_BINARIES_DIR}/boot/boot/"                || exit 1
cp "${BINARIES_DIR}/rootfs.squashfs" "${RETROLX_BINARIES_DIR}/boot/boot/retrolx.update" || exit 1
cp "${BINARIES_DIR}/modules"         "${RETROLX_BINARIES_DIR}/boot/boot/modules"         || exit 1

exit 0
