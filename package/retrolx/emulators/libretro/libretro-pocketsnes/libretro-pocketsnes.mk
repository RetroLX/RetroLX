################################################################################
#
# POCKETSNES
#
################################################################################
# Version.: Commits on Mar 12, 2021
LIBRETRO_POCKETSNES_VERSION = 48b67ee60cf32d587b2d3e9f4cd37c84c647666e
LIBRETRO_POCKETSNES_SITE = $(call github,libretro,snes9x2002,$(LIBRETRO_POCKETSNES_VERSION))
LIBRETRO_POCKETSNES_LICENSE = Non-commercial

LIBRETRO_POCKETSNES_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_POCKETSNES_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-pocketsnes

define LIBRETRO_POCKETSNES_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)
endef

define LIBRETRO_POCKETSNES_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_POCKETSNES_PKG_DIR)$(LIBRETRO_POCKETSNES_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/snes9x2002_libretro.so \
	$(LIBRETRO_POCKETSNES_PKG_DIR)$(LIBRETRO_POCKETSNES_PKG_INSTALL_DIR)/pocketsnes_libretro.so

	# Build Pacman package
	cd $(LIBRETRO_POCKETSNES_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-pocketsnes/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_POCKETSNES_POST_INSTALL_TARGET_HOOKS = LIBRETRO_POCKETSNES_MAKEPKG

$(eval $(generic-package))
