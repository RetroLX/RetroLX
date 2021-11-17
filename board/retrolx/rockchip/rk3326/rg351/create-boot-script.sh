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
cp -r "${BUILD_DIR}"/repo/* "${RETROLX_BINARIES_DIR}/boot/packages/" || exit 1

# ATF
"${BR2_EXTERNAL_RETROLX_PATH}/board/batocera/scripts/build-atf.sh" "${HOST_DIR}" "${BOARD_DIR}" "${BINARIES_DIR}" px30

# U-Boot
mkdir -p "${RETROLX_BINARIES_DIR}/build-uboot-rg351" || exit 1
cp "${BOARD_DIR}/build-uboot.sh"          "${RETROLX_BINARIES_DIR}/build-uboot-rg351/" || exit 1
cd "${RETROLX_BINARIES_DIR}/build-uboot-rg351/" && ./build-uboot.sh "${HOST_DIR}" "${BOARD_DIR}" "${BINARIES_DIR}" || exit 1

"${HOST_DIR}/bin/mkimage" -A arm64 -O linux -T kernel -C none -a 0x1080000 -e 0x1080000 -n 5.x -d "${BINARIES_DIR}/Image" "${RETROLX_BINARIES_DIR}/boot/boot/linux" || exit 1
cp "${BINARIES_DIR}/uInitrd"         "${RETROLX_BINARIES_DIR}/boot/boot/uInitrd"         || exit 1
cp "${BINARIES_DIR}/rootfs.squashfs" "${RETROLX_BINARIES_DIR}/boot/boot/batocera.update" || exit 1
cp "${BINARIES_DIR}/modules"         "${RETROLX_BINARIES_DIR}/boot/boot/modules"         || exit 1

cp "${RETROLX_BINARIES_DIR}/uboot-rg351/rg351p-uboot.dtb"  "${RETROLX_BINARIES_DIR}/boot/boot/"             || exit 1
cp "${RETROLX_BINARIES_DIR}/uboot-rg351/rg351v-uboot.dtb"  "${RETROLX_BINARIES_DIR}/boot/boot/"             || exit 1
cp "${RETROLX_BINARIES_DIR}/uboot-rg351/rg351mp-uboot.dtb" "${RETROLX_BINARIES_DIR}/boot/boot/"             || exit 1
cp "${BINARIES_DIR}/rk3326-rg351p.dtb"          "${RETROLX_BINARIES_DIR}/boot/boot/rk3326-rg351p-linux.dtb"  || exit 1
cp "${BINARIES_DIR}/rk3326-rg351v.dtb"          "${RETROLX_BINARIES_DIR}/boot/boot/rk3326-rg351v-linux.dtb"  || exit 1
cp "${BINARIES_DIR}/rk3326-rg351mp.dtb"         "${RETROLX_BINARIES_DIR}/boot/boot/rk3326-rg351mp-linux.dtb" || exit 1
cp "${BOARD_DIR}/boot/boot.ini"                 "${RETROLX_BINARIES_DIR}/boot/" || exit 1

exit 0
