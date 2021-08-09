################################################################################
#
# TYRQUAKE - Quake 1 Engine
#
################################################################################
# Version.: Commits on Aug 8, 2021
LIBRETRO_TYRQUAKE_VERSION = 8a3b3008b29b966e8edcb6ce94be91d5fd84883f
LIBRETRO_TYRQUAKE_SITE = $(call github,libretro,tyrquake,$(LIBRETRO_TYRQUAKE_VERSION))
LIBRETRO_TYRQUAKE_LICENSE = GPLv2

LIBRETRO_TYRQUAKE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_TYRQUAKE_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-tyrquake

LIBRETRO_TYRQUAKE_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S812),y)
LIBRETRO_TYRQUAKE_PLATFORM = armv

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RPI3),y)
LIBRETRO_TYRQUAKE_PLATFORM = rpi3_64

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RPI4),y)
LIBRETRO_TYRQUAKE_PLATFORM = rpi4_64

else ifeq ($(BR2_aarch64),y)
LIBRETRO_TYRQUAKE_PLATFORM = unix
endif

define LIBRETRO_TYRQUAKE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_TYRQUAKE_PLATFORM)"
endef

define LIBRETRO_TYRQUAKE_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_TYRQUAKE_PKG_DIR)$(LIBRETRO_TYRQUAKE_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/tyrquake_libretro.so \
	$(LIBRETRO_TYRQUAKE_PKG_DIR)$(LIBRETRO_TYRQUAKE_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_TYRQUAKE_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-tyrquake/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_TYRQUAKE_POST_INSTALL_TARGET_HOOKS = LIBRETRO_TYRQUAKE_MAKEPKG

$(eval $(generic-package))
