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

# ATF
"${BR2_EXTERNAL_RETROLX_PATH}/board/batocera/scripts/build-atf.sh" "${HOST_DIR}" "${BOARD_DIR}" "${BINARIES_DIR}" g12a

# U-Boot
mkdir -p "${RETROLX_BINARIES_DIR}/build-uboot-x96-max"     || exit 1
cp "${BOARD_DIR}/build-uboot.sh"          "${RETROLX_BINARIES_DIR}/build-uboot-x96-max/" || exit 1
cd "${RETROLX_BINARIES_DIR}/build-uboot-x96-max/" && ./build-uboot.sh "${HOST_DIR}" "${BOARD_DIR}" "${BINARIES_DIR}" || exit 1

# Create boot directories, copy boot files
mkdir -p "${RETROLX_BINARIES_DIR}/boot/boot"     || exit 1
mkdir -p "${RETROLX_BINARIES_DIR}/boot/extlinux" || exit 1

"${HOST_DIR}/bin/mkimage" -A arm64 -O linux -T kernel -C none -a 0x1080000 -e 0x1080000 -n linux -d "${BINARIES_DIR}/Image" "${RETROLX_BINARIES_DIR}/boot/boot/linux" || exit 1
cp "${BINARIES_DIR}/initrd.gz"       "${RETROLX_BINARIES_DIR}/boot/boot/initrd.gz"       || exit 1
cp "${BINARIES_DIR}/rootfs.squashfs" "${RETROLX_BINARIES_DIR}/boot/boot/batocera.update" || exit 1
cp "${BINARIES_DIR}/modules"         "${RETROLX_BINARIES_DIR}/boot/boot/modules"         || exit 1

cp "${BOARD_DIR}/boot/boot-logo.bmp.gz"       "${RETROLX_BINARIES_DIR}/boot/"          || exit 1
cp "${BINARIES_DIR}/meson-g12a-x96-max.dtb"   "${RETROLX_BINARIES_DIR}/boot/boot/"     || exit 1
cp "${BOARD_DIR}/boot/extlinux.conf"          "${RETROLX_BINARIES_DIR}/boot/extlinux/" || exit 1
cp "${BOARD_DIR}/boot/extlinux.conf"          "${RETROLX_BINARIES_DIR}/boot/boot/"     || exit 1
#cp "${BOARD_DIR}/boot/boot.ini"               "${RETROLX_BINARIES_DIR}/boot/"          || exit 1
#cp "${BOARD_DIR}/boot/config.ini"             "${RETROLX_BINARIES_DIR}/boot/"          || exit 1

exit 0
