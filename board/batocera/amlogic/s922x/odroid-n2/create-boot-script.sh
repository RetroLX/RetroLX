#!/bin/bash

# HOST_DIR = host dir
# BOARD_DIR = board specific dir
# BUILD_DIR = base dir/build
# BINARIES_DIR = images dir
# TARGET_DIR = target dir
# BATOCERA_BINARIES_DIR = batocera binaries

HOST_DIR=$1
BOARD_DIR=$2
BUILD_DIR=$3
BINARIES_DIR=$4
TARGET_DIR=$5
BATOCERA_BINARIES_DIR=$6

mkdir -p "${BATOCERA_BINARIES_DIR}/boot/packages" || exit 1
cp -r "${BUILD_DIR}"/repo/* "${BATOCERA_BINARIES_DIR}/boot/packages/" || exit 1

mkdir -p "${BATOCERA_BINARIES_DIR}/build-uboot-odroid-n2"     || exit 1
cp "${BOARD_DIR}/build-uboot.sh"          "${BATOCERA_BINARIES_DIR}/build-uboot-odroid-n2/" || exit 1
cd "${BATOCERA_BINARIES_DIR}/build-uboot-odroid-n2/" && ./build-uboot.sh "${HOST_DIR}" "${BOARD_DIR}" "${BINARIES_DIR}" || exit 1

# Create boot directories, copy boot files
mkdir -p "${BATOCERA_BINARIES_DIR}/boot/boot"     || exit 1
mkdir -p "${BATOCERA_BINARIES_DIR}/boot/extlinux" || exit 1

"${HOST_DIR}/bin/mkimage" -A arm64 -O linux -T kernel -C none -a 0x1080000 -e 0x1080000 -n linux -d "${BINARIES_DIR}/Image" "${BATOCERA_BINARIES_DIR}/boot/boot/linux" || exit 1
cp "${BINARIES_DIR}/uInitrd"                       "${BATOCERA_BINARIES_DIR}/boot/boot/uInitrd"                       || exit 1
cp "${BINARIES_DIR}/rootfs.squashfs"               "${BATOCERA_BINARIES_DIR}/boot/boot/batocera.update"               || exit 1
cp "${BINARIES_DIR}/modules"                       "${BATOCERA_BINARIES_DIR}/boot/boot/modules"                       || exit 1

cp "${BOARD_DIR}/boot/boot-logo.bmp.gz"            "${BATOCERA_BINARIES_DIR}/boot/"                                   || exit 1
cp "${BINARIES_DIR}/meson-g12b-odroid-n2.dtb"      "${BATOCERA_BINARIES_DIR}/boot/boot/meson-g12b-odroid-n2.dtb"      || exit 1
cp "${BOARD_DIR}/boot/extlinux.conf"               "${BATOCERA_BINARIES_DIR}/boot/extlinux/"                          || exit 1
cp "${BOARD_DIR}/boot/extlinux.conf"               "${BATOCERA_BINARIES_DIR}/boot/boot/"                              || exit 1

exit 0
