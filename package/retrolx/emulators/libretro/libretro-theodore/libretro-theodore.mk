################################################################################
#
# LIBRETRO THEODORE
#
################################################################################
# Version.: Commits on Sep 12, 2021
LIBRETRO_THEODORE_VERSION = 07d3e9c6a75fa5888bcb0ed71a67b6b433b017c3
LIBRETRO_THEODORE_SITE = $(call github,Zlika,theodore,$(LIBRETRO_THEODORE_VERSION))
LIBRETRO_THEODORE_LICENSE = GPLv3

LIBRETRO_THEODORE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_THEODORE_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-theodore

LIBRETRO_THEODORE_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
LIBRETRO_THEODORE_PLATFORM = armv

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
LIBRETRO_THEODORE_PLATFORM = rpi3_64

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
LIBRETRO_THEODORE_PLATFORM = rpi4_64

else ifeq ($(BR2_aarch64),y)
LIBRETRO_THEODORE_PLATFORM = unix
endif

define LIBRETRO_THEODORE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_THEODORE_PLATFORM)"
endef

define LIBRETRO_THEODORE_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_THEODORE_PKG_DIR)$(LIBRETRO_THEODORE_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/theodore_libretro.so \
	$(LIBRETRO_THEODORE_PKG_DIR)$(LIBRETRO_THEODORE_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_THEODORE_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-theodore/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_THEODORE_POST_INSTALL_TARGET_HOOKS = LIBRETRO_THEODORE_MAKEPKG

$(eval $(generic-package))
