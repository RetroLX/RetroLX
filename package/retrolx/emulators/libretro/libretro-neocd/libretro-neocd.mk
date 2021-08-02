
################################################################################
#
# NEOCD
#
################################################################################
# Version.: Commits on May 15, 2021
LIBRETRO_NEOCD_VERSION = ffa5ae0e853a30e87edb33bfaa5aadb86bf3058c
LIBRETRO_NEOCD_SITE = https://github.com/libretro/neocd_libretro.git
LIBRETRO_NEOCD_SITE_METHOD=git
LIBRETRO_NEOCD_GIT_SUBMODULES=YES
LIBRETRO_NEOCD_LICENSE = GPLv3

LIBRETRO_NEOCD_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_NEOCD_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-neocd

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
	cd $(LIBRETRO_NEOCD_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-neocd/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_NEOCD_POST_INSTALL_TARGET_HOOKS = LIBRETRO_NEOCD_MAKEPKG

$(eval $(generic-package))