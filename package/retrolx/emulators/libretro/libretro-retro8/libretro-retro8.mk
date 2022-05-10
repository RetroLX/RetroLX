################################################################################
#
# Retro8 - Pico-8 emulator
#
################################################################################
# Version.: Commits on Mar 2, 2022
LIBRETRO_RETRO8_VERSION = 8d074ac12634b1968f8dc10e874eb5879ad63021
LIBRETRO_RETRO8_SITE = $(call github,jakz,retro8,$(LIBRETRO_RETRO8_VERSION))
LIBRETRO_RETRO8_LICENSE = GPLv3.0

LIBRETRO_RETRO8_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_RETRO8_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-retro8

define LIBRETRO_RETRO8_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="unix"
endef

define LIBRETRO_RETRO8_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_RETRO8_PKG_DIR)$(LIBRETRO_RETRO8_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/retro8_libretro.so \
	$(LIBRETRO_RETRO8_PKG_DIR)$(LIBRETRO_RETRO8_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_RETRO8_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-retro8/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_RETRO8_POST_INSTALL_TARGET_HOOKS = LIBRETRO_RETRO8_MAKEPKG

$(eval $(generic-package))
