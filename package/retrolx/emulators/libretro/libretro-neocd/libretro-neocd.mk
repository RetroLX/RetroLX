
################################################################################
#
# NEOCD
#
################################################################################
# Version.: Commits on Mar 25, 2022
LIBRETRO_NEOCD_VERSION = 327aeceecdf71c8a0c0af3d6dc53686c94fe44ad
LIBRETRO_NEOCD_SITE = https://github.com/libretro/neocd_libretro.git
LIBRETRO_NEOCD_SITE_METHOD=git
LIBRETRO_NEOCD_GIT_SUBMODULES=YES
LIBRETRO_NEOCD_LICENSE = GPLv3

LIBRETRO_NEOCD_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_NEOCD_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-neocd

define LIBRETRO_NEOCD_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) -f Makefile platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_NEOCD_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_NEOCD_PKG_DIR)$(LIBRETRO_NEOCD_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/neocd_libretro.so \
	$(LIBRETRO_NEOCD_PKG_DIR)$(LIBRETRO_NEOCD_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_NEOCD_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-neocd/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_NEOCD_POST_INSTALL_TARGET_HOOKS = LIBRETRO_NEOCD_MAKEPKG

$(eval $(generic-package))
