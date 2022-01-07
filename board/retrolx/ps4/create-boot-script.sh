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
cat "${BUILD_DIR}/board/retrolx/packages.txt" "${BUILD_DIR}/board/retrolx/x86_64/packages.txt" > "${RETROLX_BINARIES_DIR}/boot/packages.txt"
cat "${RETROLX_BINARIES_DIR}/boot/packages.txt" | while read line; do cp "${BUILD_DIR}/repo/${line}"* "${RETROLX_BINARIES_DIR}/boot/packages/"; done

mkdir -p "${RETROLX_BINARIES_DIR}/boot/boot/syslinux" || exit 1
mkdir -p "${RETROLX_BINARIES_DIR}/boot/EFI/BOOT"      || exit 1

cp "${BINARIES_DIR}/bzImage"         "${RETROLX_BINARIES_DIR}/boot/bzImage"             || exit 1
cp "${BINARIES_DIR}/initrd.gz"       "${RETROLX_BINARIES_DIR}/boot/initramfs.cpio.gz"   || exit 1
cp "${BINARIES_DIR}/rootfs.squashfs" "${RETROLX_BINARIES_DIR}/boot/boot/retrolx.update" || exit 1
cp "${BINARIES_DIR}/modules"         "${RETROLX_BINARIES_DIR}/boot/boot/modules"        || exit 1

cp "${BOARD_DIR}/boot/syslinux.cfg"       "${RETROLX_BINARIES_DIR}/boot/boot/"          || exit 1
cp "${BOARD_DIR}/boot/syslinux.cfg"       "${RETROLX_BINARIES_DIR}/boot/boot/syslinux/" || exit 1
cp "${BINARIES_DIR}/syslinux/menu.c32"    "${RETROLX_BINARIES_DIR}/boot/boot/syslinux/" || exit 1
cp "${BINARIES_DIR}/syslinux/libutil.c32" "${RETROLX_BINARIES_DIR}/boot/boot/syslinux/" || exit 1

cp "${BOARD_DIR}/boot/bootargs.txt"  "${RETROLX_BINARIES_DIR}/boot/bootargs.txt"         || exit 1
cp "${BOARD_DIR}/boot/syslinux.cfg"             "${RETROLX_BINARIES_DIR}/boot/EFI/"      || exit 1
cp "${BOARD_DIR}/boot/syslinux.cfg"             "${RETROLX_BINARIES_DIR}/boot/EFI/BOOT/" || exit 1
cp "${BINARIES_DIR}/syslinux/efi64/menu.c32"    "${RETROLX_BINARIES_DIR}/boot/EFI/BOOT/" || exit 1
cp "${BINARIES_DIR}/syslinux/efi64/libutil.c32" "${RETROLX_BINARIES_DIR}/boot/EFI/BOOT/" || exit 1
cp "${BINARIES_DIR}/syslinux/ldlinux.e32"       "${RETROLX_BINARIES_DIR}/boot/EFI/BOOT/" || exit 1
cp "${BINARIES_DIR}/syslinux/ldlinux.e64"       "${RETROLX_BINARIES_DIR}/boot/EFI/BOOT/" || exit 1
cp "${BINARIES_DIR}/syslinux/bootx64.efi"       "${RETROLX_BINARIES_DIR}/boot/EFI/BOOT/" || exit 1
cp "${BINARIES_DIR}/syslinux/bootia32.efi"      "${RETROLX_BINARIES_DIR}/boot/EFI/BOOT/" || exit 1

exit 0
