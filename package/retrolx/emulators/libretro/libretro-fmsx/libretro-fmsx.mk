################################################################################
#
# FMSX
#
################################################################################
# Version.: Commits on May 12, 2021
LIBRETRO_FMSX_VERSION = d0581d40a40b231d619d2c5363fc2e0ecefeafbd
LIBRETRO_FMSX_SITE = $(call github,libretro,fmsx-libretro,$(LIBRETRO_FMSX_VERSION))
LIBRETRO_FMSX_LICENSE = GPLv2

LIBRETRO_FMSX_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_FMSX_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-fmsx

LIBRETRO_FMSX_PLATFORM = $(LIBRETRO_PLATFORM)
LIBRETRO_FMSX_EXTRA_ARGS =

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S812),y)
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
	cd $(LIBRETRO_FMSX_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-fmsx/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_FMSX_POST_INSTALL_TARGET_HOOKS = LIBRETRO_FMSX_MAKEPKG

$(eval $(generic-package))
