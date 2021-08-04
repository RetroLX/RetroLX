################################################################################
#
# GW
#
################################################################################
# Version.: Commits on Aug 2, 2021
LIBRETRO_GW_VERSION = 7b3e374a1067a80324f1e4905136bae357ec18da
LIBRETRO_GW_SITE = $(call github,libretro,gw-libretro,$(LIBRETRO_GW_VERSION))
LIBRETRO_GW_LICENSE = GPLv3

LIBRETRO_GW_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_GW_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-gw

define LIBRETRO_GW_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile.libretro platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_GW_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_GW_PKG_DIR)$(LIBRETRO_GW_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/gw_libretro.so \
	$(LIBRETRO_GW_PKG_DIR)$(LIBRETRO_GW_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_GW_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-gw/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_GW_POST_INSTALL_TARGET_HOOKS = LIBRETRO_GW_MAKEPKG

$(eval $(generic-package))
