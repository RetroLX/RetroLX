#!/bin/bash

HOST_DIR=$1
BOARD_DIR=$2
IMAGES_DIR=$3

# ARM Trusted Firmware BL31
export BL31="${IMAGES_DIR}/atf/gxbb/bl31.bin"

# Download U-Boot mainline
wget "https://ftp.denx.de/pub/u-boot/u-boot-2021.10.tar.bz2"
tar xf u-boot-2021.10.tar.bz2
cd u-boot-2021.10

# Apply patches
PATCHES="${BOARD_DIR}/patches/uboot/*.patch"
for patch in $PATCHES
do
  echo "Applying patch: $patch"
  patch -p1 < $patch
done

# Make config
make odroid-c2_defconfig

# Build it
ARCH=aarch64 CROSS_COMPILE="${HOST_DIR}/bin/aarch64-buildroot-linux-gnu-" make -j$(nproc)
mkdir -p ../../uboot-odroid-c2

# Clone LibreElec Amlogic FIP
git clone --depth 1 https://github.com/LibreELEC/amlogic-boot-fip
AMLOGIC_FIP_DIR="amlogic-boot-fip/odroid-c2/"

# Sign U-Boot build with Amlogic process
"${AMLOGIC_FIP_DIR}/fip_create" --bl30 "${AMLOGIC_FIP_DIR}/bl30.bin" --bl301 "${AMLOGIC_FIP_DIR}/bl301.bin" --bl31 "${IMAGES_DIR}/bl31.bin" --bl33 "u-boot.bin" "fip.bin" || exit 1
"${AMLOGIC_FIP_DIR}/fip_create" --dump "fip.bin"                || exit 1
cat "${AMLOGIC_FIP_DIR}/bl2.package" "fip.bin" > "boot_new.bin" || exit 1
"${HOST_DIR}/bin/amlbootsig" "boot_new.bin" "u-boot.img"        || exit 1
dd if="u-boot.img" of="uboot-odroid-c2.img" bs=512 skip=96      || exit 1

# Copy to appropriate place
cp "${AMLOGIC_FIP_DIR}/bl1.bin.hardkernel" ../../uboot-odroid-c2/
cp uboot-odroid-c2.img ../../uboot-odroid-c2/

