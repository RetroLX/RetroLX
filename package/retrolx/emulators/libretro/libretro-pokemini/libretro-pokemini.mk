################################################################################
#
# POKEMINI
#
################################################################################
# Version.: Commits on Sep 23, 2021
LIBRETRO_POKEMINI_VERSION = f8ab5f230dc3a01940d6f5e5e6de5a908ee9306c
LIBRETRO_POKEMINI_SITE = $(call github,libretro,PokeMini,$(LIBRETRO_POKEMINI_VERSION))
LIBRETRO_POKEMINI_LICENSE = GPLv3

LIBRETRO_POKEMINI_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_POKEMINI_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-pokemini

LIBRETRO_POKEMINI_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
LIBRETRO_POKEMINI_PLATFORM = armv

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
LIBRETRO_POKEMINI_PLATFORM = rpi3_64

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
LIBRETRO_POKEMINI_PLATFORM = rpi4

else ifeq ($(BR2_aarch64),y)
LIBRETRO_POKEMINI_PLATFORM = unix
endif

define LIBRETRO_POKEMINI_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_POKEMINI_PLATFORM)"
endef

define LIBRETRO_POKEMINI_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_POKEMINI_PKG_DIR)$(LIBRETRO_POKEMINI_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/pokemini_libretro.so \
	$(LIBRETRO_POKEMINI_PKG_DIR)$(LIBRETRO_POKEMINI_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_POKEMINI_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-pokemini/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_POKEMINI_POST_INSTALL_TARGET_HOOKS = LIBRETRO_POKEMINI_MAKEPKG

$(eval $(generic-package))
