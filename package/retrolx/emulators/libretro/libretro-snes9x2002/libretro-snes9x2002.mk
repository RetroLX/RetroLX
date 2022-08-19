################################################################################
#
# SNES9X2002
#
################################################################################
# Version.: Commits on Aug 6, 2022
LIBRETRO_SNES9X2002_VERSION = 540baad622d9833bba7e0696193cb06f5f02f564
LIBRETRO_SNES9X2002_SITE = $(call github,libretro,snes9x2002,$(LIBRETRO_SNES9X2002_VERSION))
LIBRETRO_SNES9X2002_LICENSE = Non-commercial

LIBRETRO_SNES9X2002_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_SNES9X2002_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-snes9x2002

define LIBRETRO_SNES9X2002_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)
endef

define LIBRETRO_SNES9X2002_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_SNES9X2002_PKG_DIR)$(LIBRETRO_SNES9X2002_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/snes9x2002_libretro.so \
	$(LIBRETRO_SNES9X2002_PKG_DIR)$(LIBRETRO_SNES9X2002_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_SNES9X2002_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-snes9x2002/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_SNES9X2002_POST_INSTALL_TARGET_HOOKS = LIBRETRO_SNES9X2002_MAKEPKG

$(eval $(generic-package))
