################################################################################
#
# LIBRETRO PC88
#
################################################################################
# Version. Commits on Feb 1, 2022
LIBRETRO_PC88_VERSION = f8efa75f6bbc59be6f8472f3d5e1bf49e7ea2ac9
LIBRETRO_PC88_SITE = $(call github,libretro,quasi88-libretro,$(LIBRETRO_PC88_VERSION))
LIBRETRO_PC88_LICENSE = BSD 3-Clause

LIBRETRO_PC88_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_PC88_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-pc88

define LIBRETRO_PC88_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_PC88_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_PC88_PKG_DIR)$(LIBRETRO_PC88_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/quasi88_libretro.so \
	$(LIBRETRO_PC88_PKG_DIR)$(LIBRETRO_PC88_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_PC88_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-pc88/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_PC88_POST_INSTALL_TARGET_HOOKS = LIBRETRO_PC88_MAKEPKG

$(eval $(generic-package))
