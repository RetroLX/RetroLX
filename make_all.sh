#!/bin/bash

# Raspberry pi
make rpi1-build
make rpi2-build
make rpi3-build
make rpi4-build

# Rockchip
make rk3288-build
make rk3326-build
make rk3328-build
make rk3399-build
make rk356x-build

# Amlogic
make s812-build
make s905-build
make s905gen2-build
make s905gen3-build
make s922x-build

# Samsung
make odroidxu4-build

# Allwinner
make aw32-build
make h5-build
make h6-build
make h616-build

# x86
make x86_64-build
