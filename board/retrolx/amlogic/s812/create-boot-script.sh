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

mkdir -p "${RETROLX_BINARIES_DIR}/boot/boot"     || exit 1

cp "${BINARIES_DIR}/uImage"           "${RETROLX_BINARIES_DIR}/boot/boot/uImage"           || exit 1
cp "${BINARIES_DIR}/uInitrd"       "${RETROLX_BINARIES_DIR}/boot/boot/uInitrd"       || exit 1
cp "${BINARIES_DIR}/rootfs.squashfs" "${RETROLX_BINARIES_DIR}/boot/boot/retrolx.update" || exit 1
cp "${BINARIES_DIR}/modules"         "${RETROLX_BINARIES_DIR}/boot/boot/modules"         || exit 1

cp "${BINARIES_DIR}/meson8m2-mxiii.dtb" "${RETROLX_BINARIES_DIR}/boot/boot/"     || exit 1
cp "${BINARIES_DIR}/meson8m2-mxiii-plus.dtb" "${RETROLX_BINARIES_DIR}/boot/boot/"     || exit 1
cp "${BINARIES_DIR}/meson8m2-m8s.dtb" "${RETROLX_BINARIES_DIR}/boot/boot/"     || exit 1
cp "${BINARIES_DIR}/meson8-minix-neo-x8.dtb" "${RETROLX_BINARIES_DIR}/boot/boot/"     || exit 1
cp "${BINARIES_DIR}/meson8m2-wetek-core.dtb" "${RETROLX_BINARIES_DIR}/boot/boot/"     || exit 1

"${HOST_DIR}/bin/mkimage" -C none -A arm -T script -d "${BOARD_DIR}/boot/s805_autoscript.cmd" "${RETROLX_BINARIES_DIR}/boot/s805_autoscript" || exit 1
"${HOST_DIR}/bin/mkimage" -C none -A arm -T script -d "${BOARD_DIR}/boot/aml_autoscript.scr"  "${RETROLX_BINARIES_DIR}/boot/aml_autoscript"  || exit 1
cp "${BOARD_DIR}/boot/uEnv.txt" "${RETROLX_BINARIES_DIR}/boot/uEnv.txt" || exit 1
cp "${BOARD_DIR}/boot/aml_autoscript.zip" "${RETROLX_BINARIES_DIR}/boot" || exit 1

exit 0
