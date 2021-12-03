#!/bin/bash

# Multi builds
make arm64-a53-gles2-build
make arm64-a53-gles3-build
make arm64-a55-gles3-build

# Allwinner
make aw32-build

# Amlogic
make s812-build
make s922x-build

# Raspberry Pi
make rpi1-build
make rpi2-build
make rpi3-build
make rpi4-build

# Rockchip
make rk3288-build
make rk3326-build
make rk3399-build

# Samsung
make odroidxu4-build

# x86
make x86_64-build
