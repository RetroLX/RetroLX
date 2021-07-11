################################################################################
#
# LIBRETRO HANDY
#
################################################################################
LIBRETRO_HANDY_VERSION = e5d794b8561c6c6f177aa6682950f538ee6073e4
LIBRETRO_HANDY_SITE = $(call github,libretro,libretro-handy,$(LIBRETRO_HANDY_VERSION))
LIBRETRO_HANDY_LICENSE = Zlib

LIBRETRO_HANDY_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_HANDY_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-handy


define LIBRETRO_HANDY_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_HANDY_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_HANDY_PKG_DIR)$(LIBRETRO_HANDY_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/handy_libretro.so \
	$(LIBRETRO_HANDY_PKG_DIR)$(LIBRETRO_HANDY_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_HANDY_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-handy/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_HANDY_POST_INSTALL_TARGET_HOOKS = LIBRETRO_HANDY_MAKEPKG

$(eval $(generic-package))
