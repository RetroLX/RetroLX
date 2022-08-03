################################################################################
#
# MUPEN64PLUS-NEXT
#
################################################################################
# Version.: Commits on Jul 6, 2022
LIBRETRO_MUPEN64PLUS_NEXT_VERSION = 4684cfa56ae7752be284eaaa165c1dc34ec63eb7
LIBRETRO_MUPEN64PLUS_NEXT_SITE = $(call github,libretro,mupen64plus-libretro-nx,$(LIBRETRO_MUPEN64PLUS_NEXT_VERSION))
LIBRETRO_MUPEN64PLUS_NEXT_LICENSE = GPLv2
LIBRETRO_MUPEN64PLUS_NEXT_DEPENDENCIES = host-nasm

LIBRETRO_MUPEN64PLUS_NEXT_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_MUPEN64PLUS_NEXT_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-mupen64plus-next

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
	LIBRETRO_MUPEN64PLUS_DEPENDENCIES += rpi-userland
endif

LIBRETRO_MUPEN64PLUS_NEXT_TARGET_CFLAGS = $(TARGET_CFLAGS)
LIBRETRO_MUPEN64PLUS_NEXT_TARGET_CXXFLAGS = $(TARGET_CXXFLAGS)
LIBRETRO_MUPEN64PLUS_NEXT_TARGET_LDFLAGS = $(TARGET_LDFLAGS)
LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS=
LIBRETRO_MUPEN64PLUS_NEXT_BOARD=

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
	LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = rpi4_64-mesa
	LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=aarch64 FORCE_GLES3=1

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
        LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = rpi3_64-mesa
        LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=aarch64

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI2),y)
	LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = rpi2

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
        LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = odroid
	LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=arm FORCE_GLES=1 WITH_DYNAREC=arm HAVE_NEON=1

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_EXYNOS5422),y)
	LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = odroid
	LIBRETRO_MUPEN64PLUS_NEXT_BOARD = ODROID-XU
	LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=arm FORCE_GLES3=1

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_ARM64_A53_GLES3),y)
	LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = arm64_cortex_a53_gles3
	LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=aarch64 FORCE_GLES3=1

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_ARM64_A53_GLES2),y)
	LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = arm64_cortex_a53_gles2
	LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=aarch64 FORCE_GLES=1

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_ARM64_A55_GLES3),y)
	LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = odroid64
	LIBRETRO_MUPEN64PLUS_NEXT_BOARD = ODROID-C4
	LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=aarch64 FORCE_GLES3=1

else ifeq ($(BR2_x86_i686),y)
	LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = unix
	LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=i686 HAVE_PARALLEL_RSP=1 HAVE_THR_AL=1

else ifeq ($(BR2_x86_64),y)
	LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = unix
	LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=x86_64 HAVE_PARALLEL_RSP=1 HAVE_THR_AL=1 LLE=1

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3399),y)
	LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = rpi4
	LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=aarch64 FORCE_GLES3=1

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S922X),y)
	LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = odroid64
	LIBRETRO_MUPEN64PLUS_NEXT_BOARD = N2
	LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=aarch64 FORCE_GLES3=1 GL_LIB=-lGLESv2

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3326)$(BR2_arm),yy)
	LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = odroid
	LIBRETRO_MUPEN64PLUS_NEXT_BOARD = ODROIDGOA

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3288),y)
	LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = RK3288

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_ARM32_A7_GLES2),y)
        LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = armv
        LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=arm FORCE_GLES=1 WITH_DYNAREC=arm HAVE_NEON=1

else ifeq ($(BR2_aarch64),y)
	LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM = unix
	LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS = ARCH=aarch64 FORCE_GLES=1
else
	LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM=$(LIBRETRO_PLATFORM)
endif

ifeq ($(BR2_PACKAGE_HAS_LIBMALI),y)
LIBRETRO_MUPEN64PLUS_NEXT_TARGET_LDFLAGS += -lmali
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER),)
	ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_EGL),y)
		LIBRETRO_MUPEN64PLUS_NEXT_TARGET_CFLAGS += -DEGL_NO_X11
		LIBRETRO_MUPEN64PLUS_NEXT_TARGET_CXXFLAGS += -DEGL_NO_X11
	endif
endif


define LIBRETRO_MUPEN64PLUS_NEXT_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(LIBRETRO_MUPEN64PLUS_NEXT_TARGET_CFLAGS)" \
		CXXFLAGS="$(LIBRETRO_MUPEN64PLUS_NEXT_TARGET_CXXFLAGS)" \
		LDFLAGS="$(LIBRETRO_MUPEN64PLUS_NEXT_TARGET_LDFLAGS)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_MUPEN64PLUS_NEXT_PLATFORM)" \
		BOARD="$(LIBRETRO_MUPEN64PLUS_NEXT_BOARD)" $(LIBRETRO_MUPEN64PLUS_NEXT_EXTRA_ARGS)
endef

define LIBRETRO_MUPEN64PLUS_NEXT_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_MUPEN64PLUS_NEXT_PKG_DIR)$(LIBRETRO_MUPEN64PLUS_NEXT_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/mupen64plus_next_libretro.so \
	$(LIBRETRO_MUPEN64PLUS_NEXT_PKG_DIR)$(LIBRETRO_MUPEN64PLUS_NEXT_PKG_INSTALL_DIR)/mupen64plus-next_libretro.so

	# Build Pacman package
	cd $(LIBRETRO_MUPEN64PLUS_NEXT_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-mupen64plus-next/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_MUPEN64PLUS_NEXT_POST_INSTALL_TARGET_HOOKS = LIBRETRO_MUPEN64PLUS_NEXT_MAKEPKG

$(eval $(generic-package))
