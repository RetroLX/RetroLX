################################################################################
#
# FMSX
#
################################################################################
# Version.: Commits on Dec 26, 2021
LIBRETRO_FMSX_VERSION = 1b7f15922aeabbd3d5f806c7fc25af5076ca9e73
LIBRETRO_FMSX_SITE = $(call github,libretro,fmsx-libretro,$(LIBRETRO_FMSX_VERSION))
LIBRETRO_FMSX_LICENSE = GPLv2

LIBRETRO_FMSX_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_FMSX_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-fmsx

LIBRETRO_FMSX_PLATFORM = $(LIBRETRO_PLATFORM)
LIBRETRO_FMSX_EXTRA_ARGS =

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
LIBRETRO_FMSX_PLATFORM = armv cortexa9 neon hardfloat

else ifeq ($(BR2_aarch64),y)
LIBRETRO_FMSX_PLATFORM = unix
LIBRETRO_FMSX_EXTRA_ARGS += ARCH=arm64

else ifeq ($(BR2_x86_64),y)
LIBRETRO_FMSX_EXTRA_ARGS += ARCH=x86_64
endif

define LIBRETRO_FMSX_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_FMSX_PLATFORM)" $(LIBRETRO_FMSX_EXTRA_ARGS)
endef

define LIBRETRO_FMSX_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_FMSX_PKG_DIR)$(LIBRETRO_FMSX_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/fmsx_libretro.so \
	$(LIBRETRO_FMSX_PKG_DIR)$(LIBRETRO_FMSX_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_FMSX_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-fmsx/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_FMSX_POST_INSTALL_TARGET_HOOKS = LIBRETRO_FMSX_MAKEPKG

$(eval $(generic-package))
