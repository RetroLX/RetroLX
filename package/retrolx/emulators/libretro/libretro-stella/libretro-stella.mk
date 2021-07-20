################################################################################
#
# STELLA
#
################################################################################
# Version.: Release on Apr 20, 2021
LIBRETRO_STELLA_VERSION = 6.5.3
LIBRETRO_STELLA_SITE = $(call github,stella-emu,stella,$(LIBRETRO_STELLA_VERSION))
LIBRETRO_STELLA_LICENSE = GPLv2

LIBRETRO_STELLA_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_STELLA_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-stella

define LIBRETRO_STELLA_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/src/libretro -f Makefile platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_STELLA_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_STELLA_PKG_DIR)$(LIBRETRO_STELLA_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/src/libretro/stella_libretro.so \
	$(LIBRETRO_STELLA_PKG_DIR)$(LIBRETRO_STELLA_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_STELLA_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-stella/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_STELLA_POST_INSTALL_TARGET_HOOKS = LIBRETRO_STELLA_MAKEPKG

$(eval $(generic-package))
