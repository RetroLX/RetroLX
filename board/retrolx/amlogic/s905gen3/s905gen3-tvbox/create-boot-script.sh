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
cat "${BUILD_DIR}/board/retrolx/packages.txt" "${BUILD_DIR}/board/retrolx/amlogic/s905gen3/packages.txt" > "${RETROLX_BINARIES_DIR}/boot/packages.txt"
cat "${RETROLX_BINARIES_DIR}/boot/packages.txt" | while read line; do cp "${BUILD_DIR}/repo/${line}"* "${RETROLX_BINARIES_DIR}/boot/packages/"; done

# Mainline uboot
mkdir -p "${RETROLX_BINARIES_DIR}/build-uboot-sei610"     || exit 1
cp "${BOARD_DIR}/build-uboot.sh"          "${RETROLX_BINARIES_DIR}/build-uboot-sei610/" || exit 1
cd "${RETROLX_BINARIES_DIR}/build-uboot-sei610/" && ./build-uboot.sh "${HOST_DIR}" "${BOARD_DIR}" "${BINARIES_DIR}" || exit 1

# Create boot directories, copy boot files
mkdir -p "${RETROLX_BINARIES_DIR}/boot/boot"     || exit 1
mkdir -p "${RETROLX_BINARIES_DIR}/boot/extlinux" || exit 1

cp "${BINARIES_DIR}/kernel-s905gen3/Image"           "${RETROLX_BINARIES_DIR}/boot/boot/linux"           || exit 1
cp "${BINARIES_DIR}/initrd.gz"       "${RETROLX_BINARIES_DIR}/boot/boot/initrd.gz"       || exit 1
cp "${BINARIES_DIR}/rootfs.squashfs" "${RETROLX_BINARIES_DIR}/boot/boot/retrolx.update" || exit 1
cp "${BINARIES_DIR}/kernel-s905gen3/modules"         "${RETROLX_BINARIES_DIR}/boot/boot/modules"         || exit 1

cp "${BOARD_DIR}/boot/boot-logo.bmp.gz"                "${RETROLX_BINARIES_DIR}/boot/"          || exit 1

# Copy all DTBs
for DTB in meson-sm1-h96-max.dtb meson-sm1-sei610.dtb meson-sm1-khadas-vim3l.dtb meson-sm1-odroid-c4.dtb meson-sm1-x96-air-100.dtb meson-sm1-x96-air-1000.dtb meson-sm1-a95xf3-air-100.dtb meson-sm1-a95xf3-air-1000.dtb
do
        cp "${BINARIES_DIR}/kernel-s905gen3/${DTB}" "${RETROLX_BINARIES_DIR}/boot/boot/" || exit 1
done

# Legacy/vendor uboot
cp "${BINARIES_DIR}/uInitrd"                           "${RETROLX_BINARIES_DIR}/boot/boot/uInitrd"         || exit 1
cp "${BOARD_DIR}/boot/uEnv.txt"                        "${RETROLX_BINARIES_DIR}/boot/"          || exit 1
cp "${BOARD_DIR}/boot/boot.ini"                        "${RETROLX_BINARIES_DIR}/boot/"          || exit 1
"${HOST_DIR}/bin/mkimage" -C none -A arm64 -T script -d "${BOARD_DIR}/boot/s905_autoscript.txt" "${RETROLX_BINARIES_DIR}/boot/s905_autoscript" || exit 1
"${HOST_DIR}/bin/mkimage" -C none -A arm64 -T script -d "${BOARD_DIR}/boot/aml_autoscript.txt"  "${RETROLX_BINARIES_DIR}/boot/aml_autoscript"  || exit 1
"${HOST_DIR}/bin/mkimage" -C none -A arm64 -T script -d "${BOARD_DIR}/boot/boot.scr.txt"        "${RETROLX_BINARIES_DIR}/boot/boot.scr"        || exit 1
cp "${BOARD_DIR}/boot/README.txt"                      "${RETROLX_BINARIES_DIR}/boot/"          || exit 1



exit 0
