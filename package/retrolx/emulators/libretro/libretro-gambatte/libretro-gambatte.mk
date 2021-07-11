################################################################################
#
# GAMBATTE
#
################################################################################
# Version.: Commits on May 18, 2021
LIBRETRO_GAMBATTE_VERSION = ff1ae4afe2cdf4afbf51e36a236f2f70a966dd26
LIBRETRO_GAMBATTE_SITE = $(call github,libretro,gambatte-libretro,$(LIBRETRO_GAMBATTE_VERSION))
LIBRETRO_GAMBATTE_LICENSE = GPLv2

LIBRETRO_GAMBATTE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_GAMBATTE_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-gambatte

define LIBRETRO_GAMBATTE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) -f Makefile platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_GAMBATTE_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_GAMBATTE_PKG_DIR)$(LIBRETRO_GAMBATTE_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/gambatte_libretro.so \
	$(LIBRETRO_GAMBATTE_PKG_DIR)$(LIBRETRO_GAMBATTE_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_GAMBATTE_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-gambatte/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_GAMBATTE_POST_INSTALL_TARGET_HOOKS = LIBRETRO_GAMBATTE_MAKEPKG

$(eval $(generic-package))
