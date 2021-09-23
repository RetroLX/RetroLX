#!/bin/bash

# HOST_DIR = host dir
# BOARD_DIR = board specific dir
# BUILD_DIR = base dir/build
# BINARIES_DIR = images dir
# TARGET_DIR = target dir
# BATOCERA_BINARIES_DIR = batocera binaries sub directory
# BATOCERA_TARGET_DIR = batocera target sub directory

HOST_DIR=$1
BOARD_DIR=$2
BUILD_DIR=$3
BINARIES_DIR=$4
TARGET_DIR=$5
BATOCERA_BINARIES_DIR=$6

mkdir -p "${BATOCERA_BINARIES_DIR}/boot/boot" || exit 1
mkdir -p "${BATOCERA_BINARIES_DIR}/boot/extlinux" || exit 1
mkdir -p "${BATOCERA_BINARIES_DIR}/boot/packages" || exit 1
cp -r "${BUILD_DIR}"/repo/* "${BATOCERA_BINARIES_DIR}/boot/packages/" || exit 1

mkdir -p "${BATOCERA_BINARIES_DIR}/uboot-firefly-station-p2"     || exit 1
cp "${BOARD_DIR}/build-uboot.sh"          "${BATOCERA_BINARIES_DIR}/uboot-firefly-station-p2/" || exit 1
cd "${BATOCERA_BINARIES_DIR}/uboot-firefly-station-p2/" && ./build-uboot.sh "${HOST_DIR}" "${BOARD_DIR}" "${BINARIES_DIR}" || exit 1
cp "${BOARD_DIR}/idbloader.img"  "${BATOCERA_BINARIES_DIR}/uboot-firefly-station-p2/" || exit 1

"${HOST_DIR}/bin/mkimage" -A arm64 -O linux -T kernel -C none -a 0x1080000 -e 0x1080000 -n 5.x -d "${BINARIES_DIR}/Image" "${BATOCERA_BINARIES_DIR}/boot/boot/linux" || exit 1
cp "${BINARIES_DIR}/initrd.gz"             "${BATOCERA_BINARIES_DIR}/boot/boot/initrd.gz"             || exit 1
cp "${BINARIES_DIR}/rootfs.squashfs"       "${BATOCERA_BINARIES_DIR}/boot/boot/batocera.update"       || exit 1
cp "${BINARIES_DIR}/modules"               "${BATOCERA_BINARIES_DIR}/boot/boot/modules"               || exit 1
cp "${BINARIES_DIR}/rk3568-evb1-v10.dtb"   "${BATOCERA_BINARIES_DIR}/boot/boot/rk3568-evb1-v10.dtb"   || exit 1
cp "${BOARD_DIR}/boot/extlinux.conf"       "${BATOCERA_BINARIES_DIR}/boot/extlinux/"                  || exit 1
cp "${BOARD_DIR}/boot/extlinux.conf"       "${BATOCERA_BINARIES_DIR}/boot/boot/"                      || exit 1

exit 0
