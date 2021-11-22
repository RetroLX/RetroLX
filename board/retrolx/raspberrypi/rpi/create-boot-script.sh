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
cp -r "${BUILD_DIR}"/repo/* "${RETROLX_BINARIES_DIR}/boot/packages/" || exit 1

mkdir -p "${RETROLX_BINARIES_DIR}/boot/boot"         || exit 1

cp -pr "${BINARIES_DIR}/rpi-firmware/"* "${RETROLX_BINARIES_DIR}/boot/" || exit 1
cp -f "${BINARIES_DIR}/"*.dtb      	"${RETROLX_BINARIES_DIR}/boot/" || exit 1
cp "${BOARD_DIR}/boot/config.txt"  	"${RETROLX_BINARIES_DIR}/boot/" || exit 1
cp "${BOARD_DIR}/boot/cmdline.txt" 	"${RETROLX_BINARIES_DIR}/boot/" || exit 1

KERNEL_VERSION=$(grep -E "^BR2_LINUX_KERNEL_VERSION=" "${BR2_CONFIG}" | sed -e s+'^BR2_LINUX_KERNEL_VERSION="\(.*\)"$'+'\1'+)
cp "${BINARIES_DIR}/zImage"          "${RETROLX_BINARIES_DIR}/boot/boot/linux"           || exit 1
cp "${BINARIES_DIR}/initrd.gz"       "${RETROLX_BINARIES_DIR}/boot/boot"                 || exit 1
cp "${BINARIES_DIR}/rootfs.squashfs" "${RETROLX_BINARIES_DIR}/boot/boot/retrolx.update" || exit 1
cp "${BINARIES_DIR}/modules"         "${RETROLX_BINARIES_DIR}/boot/boot/modules"         || exit 1

exit 0
