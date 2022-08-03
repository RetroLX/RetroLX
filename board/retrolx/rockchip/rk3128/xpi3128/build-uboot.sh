#!/bin/bash

HOST_DIR=$1
IMAGES_DIR=$2

# Clone U-Boot mainline
wget "https://ftp.denx.de/pub/u-boot/u-boot-2022.07.tar.bz2"
tar xf u-boot-2022.07.tar.bz2
cd u-boot-2022.07

# Apply patches
PATCHES="${BOARD_DIR}/patches/uboot/*.patch"
for patch in $PATCHES
do
  echo "Applying patch: $patch"
  patch -p1 < $patch
done

# Make config
make evb-rk3128_defconfig

# Build it
ARCH=arm CROSS_COMPILE="${HOST_DIR}/bin/arm-buildroot-linux-gnueabihf-" make -j$(nproc) all
mkdir -p ../../uboot-xpi3128

# Rockchip process
git clone https://github.com/rockchip-linux/rkbin.git
cd rkbin
"${HOST_DIR}/bin/mkimage" -n rk3128 -T rksd -d "bin/rk31/rk3128_ddr_300MHz_v2.12.bin" "../idbloader.img" || exit 1
cat "bin/rk31/rk3128x_miniloader_v2.57.bin" >> "../idbloader.img"
./tools/loaderimage --pack --uboot "../u-boot-dtb.bin" "../u-boot.img" --size 1024 4
./tools/loaderimage --pack --trustos "bin/rk31/rk3126_tee_ta_v2.01.bin" "../trust.img" --size 1024 4
cd ..

# Copy to appropriate place
cp idbloader.img ../../uboot-xpi3128/
cp u-boot.img ../../uboot-xpi3128/
cp trust.img ../../uboot-xpi3128/
