#!/bin/bash

HOST_DIR=$1
BOARD_DIR=$2
IMAGES_DIR=$3

# ARM Trusted Firmware BL31
# export BL31="${IMAGES_DIR}/atf/gxbb/bl31.bin"

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
make khadas-vim_defconfig

# Build it
ARCH=aarch64 CROSS_COMPILE="${HOST_DIR}/bin/aarch64-buildroot-linux-gnu-" make -j$(nproc)
mkdir -p ../../uboot-khadas-vim

# Clone LibreElec Amlogic FIP
git clone --depth 1 https://github.com/LibreELEC/amlogic-boot-fip
AMLOGIC_FIP_DIR="amlogic-boot-fip/khadas-vim"

# Sign U-Boot build with Amlogic process
"${AMLOGIC_FIP_DIR}/blx_fix.sh" \
	"${AMLOGIC_FIP_DIR}/bl30.bin" \
	"${AMLOGIC_FIP_DIR}/zero_tmp" \
	"${AMLOGIC_FIP_DIR}/bl30_zero.bin" \
	"${AMLOGIC_FIP_DIR}/bl301.bin" \
	"${AMLOGIC_FIP_DIR}/bl301_zero.bin" \
	"${AMLOGIC_FIP_DIR}/bl30_new.bin" \
	bl30 || exit 1

"${AMLOGIC_FIP_DIR}/fip_create" --bl30 "${AMLOGIC_FIP_DIR}/bl30_new.bin" --bl31 "${AMLOGIC_FIP_DIR}/bl31.img" --bl33 "u-boot.bin" "${AMLOGIC_FIP_DIR}/fip.bin" || exit 1
"${HOST_DIR}/bin/python" "${AMLOGIC_FIP_DIR}/acs_tool.py" "${AMLOGIC_FIP_DIR}/bl2.bin" "${AMLOGIC_FIP_DIR}/bl2_acs.bin" "${AMLOGIC_FIP_DIR}/acs.bin" 0 || exit 1

"${AMLOGIC_FIP_DIR}/blx_fix.sh" \
	"${AMLOGIC_FIP_DIR}/bl2_acs.bin" \
    	"${AMLOGIC_FIP_DIR}/zero_tmp" \
	"${AMLOGIC_FIP_DIR}/bl2_zero.bin" \
	"${AMLOGIC_FIP_DIR}/bl21.bin" \
	"${AMLOGIC_FIP_DIR}/bl21_zero.bin" \
	"${AMLOGIC_FIP_DIR}/bl2_new.bin" \
	bl2 || exit 1

cat "${AMLOGIC_FIP_DIR}/bl2_new.bin" "${AMLOGIC_FIP_DIR}/fip.bin" > "${AMLOGIC_FIP_DIR}/boot_new.bin" || exit 1
"${AMLOGIC_FIP_DIR}/aml_encrypt_gxl" --bootsig --input "${AMLOGIC_FIP_DIR}/boot_new.bin" --output "${AMLOGIC_FIP_DIR}/uboot-khadas-vim.img" || exit 1

# Copy to appropriate place
cp "${AMLOGIC_FIP_DIR}/uboot-khadas-vim.img" ../../uboot-khadas-vim/
