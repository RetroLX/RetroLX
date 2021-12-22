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
cat "${BUILD_DIR}/board/retrolx/packages.txt" "${BUILD_DIR}/board/retrolx/amlogic/s905/packages.txt" > "${RETROLX_BINARIES_DIR}/boot/packages.txt"
cat "${RETROLX_BINARIES_DIR}/boot/packages.txt" | while read line; do cp "${BUILD_DIR}/repo/${line}"* "${RETROLX_BINARIES_DIR}/boot/packages/"; done

# Create boot directories
mkdir -p "${RETROLX_BINARIES_DIR}/boot/boot" 	  || exit 1
mkdir -p "${RETROLX_BINARIES_DIR}/boot/extlinux" || exit 1

# Copy kernel files
"${HOST_DIR}/bin/mkimage" -A arm64 -O linux -T kernel -C none -a 0x1080000 -e 0x1080000 -n linux -d "${BINARIES_DIR}/kernel-meson64/Image" "${RETROLX_BINARIES_DIR}/boot/boot/uImage" || exit 1
cp "${BINARIES_DIR}/kernel-meson64/modules"         "${RETROLX_BINARIES_DIR}/boot/boot/modules"         || exit 1
for DTB in meson-gxbb-minix-neo-u1.dtb meson-gxbb-nexbox-a95x.dtb meson-gxl-s905d-p230.dtb meson-gxl-s905d-p231.dtb meson-gxl-s905w-p281.dtb meson-gxl-s905w-tx3-mini.dtb meson-gxl-s905x-p212.dtb
do
	cp "${BINARIES_DIR}/kernel-meson64/${DTB}" "${RETROLX_BINARIES_DIR}/boot/boot/" || exit 1
done

# Copy rootfs, initrd and extlinux
cp "${BINARIES_DIR}/uInitrd"         "${RETROLX_BINARIES_DIR}/boot/boot/uInitrd"         || exit 1
cp "${BINARIES_DIR}/rootfs.squashfs" "${RETROLX_BINARIES_DIR}/boot/boot/retrolx.update" || exit 1
cp "${BOARD_DIR}/boot/boot-logo.bmp.gz" 	"${RETROLX_BINARIES_DIR}/boot/"	  || exit 1
cp "${BOARD_DIR}/boot/README.txt"       	"${RETROLX_BINARIES_DIR}/boot/"	  || exit 1
cp "${BOARD_DIR}/boot/uEnv.txt"       		"${RETROLX_BINARIES_DIR}/boot/" 	  || exit 1
"${HOST_DIR}/bin/mkimage" -C none -A arm64 -T script -d "${BOARD_DIR}/boot/s905_autoscript.txt" "${RETROLX_BINARIES_DIR}/boot/s905_autoscript" || exit 1
"${HOST_DIR}/bin/mkimage" -C none -A arm64 -T script -d "${BOARD_DIR}/boot/aml_autoscript.txt"  "${RETROLX_BINARIES_DIR}/boot/aml_autoscript"  || exit 1
cp "${BOARD_DIR}/boot/aml_autoscript.zip" "${RETROLX_BINARIES_DIR}/boot" || exit 1

exit 0
