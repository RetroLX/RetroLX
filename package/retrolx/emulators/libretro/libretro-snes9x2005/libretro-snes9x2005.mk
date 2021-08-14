################################################################################
#
# SNES9X2005
#
################################################################################
# Version.: Commits on Jun 7, 2021
LIBRETRO_SNES9X2005_VERSION = 71db1be367d780caa6128bc2a3c3bd33567baf5a
LIBRETRO_SNES9X2005_SITE = $(call github,libretro,snes9x2005,$(LIBRETRO_SNES9X2005_VERSION))
LIBRETRO_SNES9X2005_LICENSE = Non-commercial

LIBRETRO_SNES9X2005_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_SNES9X2005_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-snes9x2005

define LIBRETRO_SNES9X2005_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)
endef

define LIBRETRO_SNES9X2005_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_SNES9X2005_PKG_DIR)$(LIBRETRO_SNES9X2005_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/snes9x2005_libretro.so \
	$(LIBRETRO_SNES9X2005_PKG_DIR)$(LIBRETRO_SNES9X2005_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_SNES9X2005_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-snes9x2005/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_SNES9X2005_POST_INSTALL_TARGET_HOOKS = LIBRETRO_SNES9X2005_MAKEPKG

$(eval $(generic-package))
