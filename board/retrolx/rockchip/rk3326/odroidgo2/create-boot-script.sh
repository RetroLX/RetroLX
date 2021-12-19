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

mkdir -p "${RETROLX_BINARIES_DIR}/boot/boot" || exit 1

mkdir -p "${RETROLX_BINARIES_DIR}/boot/packages" || exit 1
cat "${BUILD_DIR}/board/retrolx/packages.txt" "${BUILD_DIR}/board/retrolx/rockchip/rk3326/packages.txt" > "${RETROLX_BINARIES_DIR}/boot/packages.txt"
cat "${RETROLX_BINARIES_DIR}/boot/packages.txt" | while read line; do cp "${BUILD_DIR}/repo/${line}"* "${RETROLX_BINARIES_DIR}/boot/packages/"; done

# ATF
"${BR2_EXTERNAL_RETROLX_PATH}/board/retrolx/scripts/build-atf.sh" "${HOST_DIR}" "${BOARD_DIR}" "${BINARIES_DIR}" px30

# U-Boot
mkdir -p "${RETROLX_BINARIES_DIR}/build-uboot-odroidgo2" || exit 1
cp "${BOARD_DIR}/build-uboot.sh"          "${RETROLX_BINARIES_DIR}/build-uboot-odroidgo2/" || exit 1
cd "${RETROLX_BINARIES_DIR}/build-uboot-odroidgo2/" && ./build-uboot.sh "${HOST_DIR}" "${BOARD_DIR}" "${BINARIES_DIR}" || exit 1

"${HOST_DIR}/bin/mkimage" -A arm64 -O linux -T kernel -C none -a 0x1080000 -e 0x1080000 -n 5.x -d "${BINARIES_DIR}/Image" "${RETROLX_BINARIES_DIR}/boot/boot/linux" || exit 1
cp "${BINARIES_DIR}/uInitrd"         "${RETROLX_BINARIES_DIR}/boot/boot/uInitrd"         || exit 1
cp "${BINARIES_DIR}/rootfs.squashfs" "${RETROLX_BINARIES_DIR}/boot/boot/retrolx.update" || exit 1
cp "${BINARIES_DIR}/modules"         "${RETROLX_BINARIES_DIR}/boot/boot/modules"         || exit 1

cp "${BINARIES_DIR}/rk3326-odroid-go2.dtb"     "${RETROLX_BINARIES_DIR}/boot/boot/rk3326-odroid-go2.dtb"     || exit 1
cp "${BINARIES_DIR}/rk3326-odroid-go2-v11.dtb" "${RETROLX_BINARIES_DIR}/boot/boot/rk3326-odroid-go2-v11.dtb" || exit 1
cp "${BINARIES_DIR}/rk3326-odroid-go3.dtb"     "${RETROLX_BINARIES_DIR}/boot/boot/rk3326-odroid-go3.dtb"     || exit 1

cp "${BOARD_DIR}/boot/boot.ini"                     "${RETROLX_BINARIES_DIR}/boot/"                          || exit 1

exit 0
