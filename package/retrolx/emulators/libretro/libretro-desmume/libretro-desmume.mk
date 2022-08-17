################################################################################
#
# DESMUME
#
################################################################################
# Version.: Commits on Jul 29, 2022
LIBRETRO_DESMUME_VERSION = fb05195a535c834cbb521337b45eb09262f6fdb2
LIBRETRO_DESMUME_SITE = $(call github,libretro,desmume,$(LIBRETRO_DESMUME_VERSION))
LIBRETRO_DESMUME_LICENSE = GPLv2
LIBRETRO_DESMUME_DEPENDENCIES = libpcap

LIBRETRO_DESMUME_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_DESMUME_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-desmume

define LIBRETRO_DESMUME_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/desmume/src/frontend/libretro -f Makefile platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_DESMUME_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_DESMUME_PKG_DIR)$(LIBRETRO_DESMUME_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/desmume/src/frontend/libretro/desmume_libretro.so \
	$(LIBRETRO_DESMUME_PKG_DIR)$(LIBRETRO_DESMUME_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_DESMUME_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-desmume/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_DESMUME_POST_INSTALL_TARGET_HOOKS = LIBRETRO_DESMUME_MAKEPKG

$(eval $(generic-package))
