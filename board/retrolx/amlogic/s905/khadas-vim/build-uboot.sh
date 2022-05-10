#!/bin/bash

HOST_DIR=$1
BOARD_DIR=$2
IMAGES_DIR=$3

# ARM Trusted Firmware BL31
# export BL31="${IMAGES_DIR}/atf/gxbb/bl31.bin"

# Download U-Boot mainline
wget "https://ftp.denx.de/pub/u-boot/u-boot-2022.04.tar.bz2"
tar xf u-boot-2022.04.tar.bz2
cd u-boot-2022.04

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

# Sign U-Boot build with Amlogic process
AML_FIP_DIR="amlogic-boot-fip/khadas-vim"
AML_ENCRYPT_BIN="aml_encrypt_gxl"
cp u-boot.bin ${AML_FIP_DIR}/bl33.bin
${AML_FIP_DIR}/blx_fix.sh ${AML_FIP_DIR}/bl30.bin \
  ${AML_FIP_DIR}/zero_tmp \
  ${AML_FIP_DIR}/bl30_zero.bin \
  ${AML_FIP_DIR}/bl301.bin \
  ${AML_FIP_DIR}/bl301_zero.bin \
  ${AML_FIP_DIR}/bl30_new.bin bl30
${HOST_DIR}/bin/python ${AML_FIP_DIR}/acs_tool.py ${AML_FIP_DIR}/bl2.bin ${AML_FIP_DIR}/bl2_acs.bin ${AML_FIP_DIR}/acs.bin 0
${AML_FIP_DIR}/blx_fix.sh ${AML_FIP_DIR}/bl2_acs.bin \
  ${AML_FIP_DIR}/zero_tmp \
  ${AML_FIP_DIR}/bl2_zero.bin \
  ${AML_FIP_DIR}/bl21.bin \
  ${AML_FIP_DIR}/bl21_zero.bin \
  ${AML_FIP_DIR}/bl2_new.bin bl2
${AML_FIP_DIR}/${AML_ENCRYPT_BIN} --bl3enc --input ${AML_FIP_DIR}/bl30_new.bin
${AML_FIP_DIR}/${AML_ENCRYPT_BIN} --bl3enc --input ${AML_FIP_DIR}/bl31.img
${AML_FIP_DIR}/${AML_ENCRYPT_BIN} --bl3enc --input ${AML_FIP_DIR}/bl33.bin
${AML_FIP_DIR}/${AML_ENCRYPT_BIN} --bl2sig --input ${AML_FIP_DIR}/bl2_new.bin --output ${AML_FIP_DIR}/bl2.n.bin.sig
${AML_FIP_DIR}/${AML_ENCRYPT_BIN} --bootmk \
  --output ${AML_FIP_DIR}/u-boot.bin \
  --bl2 ${AML_FIP_DIR}/bl2.n.bin.sig \
  --bl30 ${AML_FIP_DIR}/bl30_new.bin.enc \
  --bl31 ${AML_FIP_DIR}/bl31.img.enc \
  --bl33 ${AML_FIP_DIR}/bl33.bin.enc

# Copy to appropriate place
cp ${AML_FIP_DIR}/u-boot.bin.sd.bin ../../uboot-khadas-vim/

