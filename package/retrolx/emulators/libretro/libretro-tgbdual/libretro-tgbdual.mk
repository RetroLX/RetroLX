################################################################################
#
# TGBDUAL
#
################################################################################
# Version.: Commits on Mar 12, 2021
LIBRETRO_TGBDUAL_VERSION = 1e0c4f931d8c5e859e6d3255d67247d7a2987434
LIBRETRO_TGBDUAL_SITE = $(call github,libretro,tgbdual-libretro,$(LIBRETRO_TGBDUAL_VERSION))
LIBRETRO_TGBDUAL_LICENSE = GPLv2

LIBRETRO_TGBDUAL_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_TGBDUAL_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-tgbdual

define LIBRETRO_TGBDUAL_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)
endef

define LIBRETRO_TGBDUAL_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_TGBDUAL_PKG_DIR)$(LIBRETRO_TGBDUAL_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/tgbdual_libretro.so \
	$(LIBRETRO_TGBDUAL_PKG_DIR)$(LIBRETRO_TGBDUAL_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_TGBDUAL_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-tgbdual/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_TGBDUAL_POST_INSTALL_TARGET_HOOKS = LIBRETRO_TGBDUAL_MAKEPKG

$(eval $(generic-package))

