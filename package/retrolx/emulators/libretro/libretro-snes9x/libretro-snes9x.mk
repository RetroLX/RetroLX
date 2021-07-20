################################################################################
#
# SNES9X
#
################################################################################
# Version.: Commits on May 16, 2021
LIBRETRO_SNES9X_VERSION = 937c177ef5c8a5d8e535d00d28acf7125593b4ba
LIBRETRO_SNES9X_SITE = $(call github,libretro,snes9x,$(LIBRETRO_SNES9X_VERSION))
LIBRETRO_SNES9X_LICENSE = Non-commercial

LIBRETRO_SNES9X_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_SNES9X_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-snes9x

LIBRETRO_SNES9X_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S922X),y)
LIBRETRO_SNES9X_PLATFORM = CortexA73_G12B
else ifeq ($(BR2_aarch64),y)
LIBRETRO_SNES9X_PLATFORM = unix
endif

define LIBRETRO_SNES9X_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/libretro -f Makefile platform="$(LIBRETRO_SNES9X_PLATFORM)"
endef

define LIBRETRO_SNES9X_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_SNES9X_PKG_DIR)$(LIBRETRO_SNES9X_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/libretro/snes9x_libretro.so \
	$(LIBRETRO_SNES9X_PKG_DIR)$(LIBRETRO_SNES9X_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_SNES9X_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-snes9x/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_SNES9X_POST_INSTALL_TARGET_HOOKS = LIBRETRO_SNES9X_MAKEPKG

$(eval $(generic-package))
