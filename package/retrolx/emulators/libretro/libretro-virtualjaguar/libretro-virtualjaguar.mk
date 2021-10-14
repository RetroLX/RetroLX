################################################################################
#
# VIRTUALJAGUAR
#
################################################################################
# Version.: Commits on Oct 8, 2021
LIBRETRO_VIRTUALJAGUAR_VERSION = 390c44ddd22657cec3757ffe260a10ad88416726
LIBRETRO_VIRTUALJAGUAR_SITE = $(call github,libretro,virtualjaguar-libretro,$(LIBRETRO_VIRTUALJAGUAR_VERSION))
LIBRETRO_VIRTUALJAGUAR_LICENSE = GPLv3

LIBRETRO_VIRTUALJAGUAR_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_VIRTUALJAGUAR_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-virtualjaguar

define LIBRETRO_VIRTUALJAGUAR_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)
endef

define LIBRETRO_VIRTUALJAGUAR_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_VIRTUALJAGUAR_PKG_DIR)$(LIBRETRO_VIRTUALJAGUAR_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/virtualjaguar_libretro.so \
	$(LIBRETRO_VIRTUALJAGUAR_PKG_DIR)$(LIBRETRO_VIRTUALJAGUAR_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_VIRTUALJAGUAR_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-virtualjaguar/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_VIRTUALJAGUAR_POST_INSTALL_TARGET_HOOKS = LIBRETRO_VIRTUALJAGUAR_MAKEPKG

$(eval $(generic-package))
