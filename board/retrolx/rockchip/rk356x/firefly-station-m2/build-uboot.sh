#!/bin/bash

HOST_DIR=$1
BOARD_DIR=$2
IMAGES_DIR=$3

# Clone U-Boot mainline
#wget "https://ftp.denx.de/pub/u-boot/u-boot-2022.01.tar.bz2"
#tar xf u-boot-2022.01.tar.bz2
#cd u-boot-2022.01

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

# UART hack
#sed -i "s+CONFIG_BAUDRATE=1500000+CONFIG_BAUDRATE=115200+g" configs/evb-rk3568_defconfig
#sed -i "s+CONFIG_BAUDRATE=1500000+CONFIG_BAUDRATE=115200+g" configs/rk3568_defconfig

# No android hack
#sed -i "s+CONFIG_ANDROID_BOOTLOADER=y+# CONFIG_ANDROID_BOOTLOADER is not set+g" configs/firefly-rk3568_defconfig
#sed -i "s+CONFIG_ANDROID_AVB=y+# CONFIG_ANDROID_AVB is not set+g" configs/firefly-rk3568_defconfig
#sed -i "s+CONFIG_ANDROID_BOOT_IMAGE_HASH=y+# CONFIG_ANDROID_BOOT_IMAGE_HASH is not set+g" configs/firefly-rk3568_defconfig
#sed -i "s+CONFIG_CMD_BOOT_ANDROID=y+# CONFIG_CMD_BOOT_ANDROID is not set+g" configs/firefly-rk3568_defconfig
#sed -i "s+CONFIG_AVB_LIBAVB=y+# CONFIG_AVB_LIBAVB is not set+g" configs/firefly-rk3568_defconfig
#sed -i "s+CONFIG_AVB_LIBAVB_AB=y+# CONFIG_AVB_LIBAVB_AB is not set+g" configs/firefly-rk3568_defconfig
#sed -i "s+CONFIG_AVB_LIBAVB_ATX=y+# CONFIG_AVB_LIBAVB_ATX is not set+g" configs/firefly-rk3568_defconfig
#sed -i "s+CONFIG_AVB_LIBAVB_USER=y+# CONFIG_AVB_LIBAVB_USER is not set+g" configs/firefly-rk3568_defconfig
#sed -i "s+CONFIG_RK_AVB_LIBAVB_USER=y+# CONFIG_RK_AVB_LIBAVB_USER is not set+g" configs/firefly-rk3568_defconfig
#sed -i "s+CONFIG_CMD_BOOT_ROCKCHIP=y+# CONFIG_CMD_BOOT_ROCKCHIP is not set+g" configs/firefly-rk3568_defconfig
#sed -i "s+CONFIG_ANDROID_BOOTLOADER=y+# CONFIG_ANDROID_BOOTLOADER is not set+g" configs/rk3568_defconfig
#sed -i "s+CONFIG_ANDROID_AVB=y+# CONFIG_ANDROID_AVB is not set+g" configs/rk3568_defconfig
#sed -i "s+CONFIG_ANDROID_BOOT_IMAGE_HASH=y+# CONFIG_ANDROID_BOOT_IMAGE_HASH is not set+g" configs/rk3568_defconfig
#sed -i "s+CONFIG_CMD_BOOT_ANDROID=y+# CONFIG_CMD_BOOT_ANDROID is not set+g" configs/rk3568_defconfig
#sed -i "s+CONFIG_AVB_LIBAVB=y+# CONFIG_AVB_LIBAVB is not set+g" configs/rk3568_defconfig
#sed -i "s+CONFIG_AVB_LIBAVB_AB=y+# CONFIG_AVB_LIBAVB_AB is not set+g" configs/rk3568_defconfig
#sed -i "s+CONFIG_AVB_LIBAVB_ATX=y+# CONFIG_AVB_LIBAVB_ATX is not set+g" configs/rk3568_defconfig
#sed -i "s+CONFIG_AVB_LIBAVB_USER=y+# CONFIG_AVB_LIBAVB_USER is not set+g" configs/rk3568_defconfig
#sed -i "s+CONFIG_RK_AVB_LIBAVB_USER=y+# CONFIG_RK_AVB_LIBAVB_USER is not set+g" configs/rk3568_defconfig
#sed -i "s+CONFIG_CMD_BOOT_ROCKCHIP=y+# CONFIG_CMD_BOOT_ROCKCHIP is not set+g" configs/rk3568_defconfig

# Make config and build
#make firefly-rk3566_defconfig
#ARCH=aarch64 CROSS_COMPILE="${HOST_DIR}/bin/aarch64-buildroot-linux-gnu-" make -j$(nproc)
#mkdir -p ../../uboot-rk3568

#make evb-rk3568_defconfig
#ARCH=aarch64 CROSS_COMPILE="${HOST_DIR}/bin/aarch64-buildroot-linux-gnu-" make -j$(nproc)

# Rockchip process
#git clone https://github.com/rockchip-linux/rkbin.git
#cd rkbin
#./tools/trust_merger ./RKTRUST/RK3568TRUST.ini
#./tools/loaderimage --pack --uboot ../u-boot-dtb.bin uboot.img
#./tools/boot_merger RKBOOT/RK3566MINIALL.ini
#cd ..

# Build it
make clean
./make.sh firefly-rk3566
./make.sh uboot
./make.sh trust
./make.sh loader

# Copy generated files
dd if="rk356x_spl_loader_v1.11.112.bin" of="../idbloader.img" bs=1 skip=444
cp "uboot.img" "../uboot.img"
#cp "../rkbin/trust.img" "../trust.img"
