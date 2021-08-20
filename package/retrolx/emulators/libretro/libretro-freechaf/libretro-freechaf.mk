################################################################################
#
# FreeChaF - Fairchild Channel F emulator
#
################################################################################
# Version.: Commits on Aug 18, 2021
LIBRETRO_FREECHAF_VERSION = 7275a3e067ed3fd701e0bbcfbcfec8f528587735
LIBRETRO_FREECHAF_SITE_METHOD=git
LIBRETRO_FREECHAF_SITE=https://github.com/libretro/FreeChaF.git
LIBRETRO_FREECHAF_GIT_SUBMODULES=YES
LIBRETRO_FREECHAF_LICENSE = GPLv3.0

LIBRETRO_FREECHAF_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_FREECHAF_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-freechaf

define LIBRETRO_FREECHAF_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="unix"
endef

define LIBRETRO_FREECHAF_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_FREECHAF_PKG_DIR)$(LIBRETRO_FREECHAF_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/freechaf_libretro.so \
	$(LIBRETRO_FREECHAF_PKG_DIR)$(LIBRETRO_FREECHAF_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_FREECHAF_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-freechaf/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_FREECHAF_POST_INSTALL_TARGET_HOOKS = LIBRETRO_FREECHAF_MAKEPKG

$(eval $(generic-package))
