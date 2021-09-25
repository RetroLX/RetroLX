#!/bin/bash

HOST_DIR=$1
BOARD_DIR=$2
IMAGES_DIR=$3

# Clone vendor U-Boot and rkbin
git clone https://gitlab.com/firefly-linux/u-boot -b rk356x/firefly
git clone https://gitlab.com/firefly-linux/rkbin
# Clone vendor toolchains
mkdir -p prebuilts/gcc/linux-x86/aarch64
cd prebuilts/gcc/linux-x86/aarch64
git clone https://gitlab.com/firefly-linux/prebuilts/gcc/linux-x86/aarch64/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu
cd ../../../..
mkdir -p prebuilts/gcc/linux-x86/arm
cd prebuilts/gcc/linux-x86/arm
git clone https://gitlab.com/firefly-linux/prebuilts/gcc/linux-x86/arm/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf
cd ../../../..

# Enter build directory
cd u-boot

# Apply patches
PATCHES="${BOARD_DIR}/patches/uboot/*.patch"
for patch in $PATCHES
do
  echo "Applying patch: $patch"
  patch -p1 < $patch
done

# Make config and build
#make firefly-rk3566_defconfig
#ARCH=aarch64 CROSS_COMPILE="${HOST_DIR}/bin/aarch64-buildroot-linux-gnu-" make -j$(nproc)
#mkdir -p ../../uboot-rk3568

# Rockchip process
#git clone https://github.com/rockchip-linux/rkbin.git
#cd rkbin
#./tools/trust_merger ./RKTRUST/RK3568TRUST.ini
#./tools/loaderimage --pack --uboot ../u-boot-dtb.bin uboot.img
#cd ..

# Build it
./make.sh firefly-rk3566

# Copy generated files
cp "rk356x_spl_loader_v1.09.111.bin" "../idbloader.img"
cp "uboot.img" "../uboot.img"
