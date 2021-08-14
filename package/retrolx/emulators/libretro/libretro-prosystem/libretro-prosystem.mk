################################################################################
#
# PROSYSTEM
#
################################################################################
# Version.: Commits on Aug 3, 2021
LIBRETRO_PROSYSTEM_VERSION = d365645a460d5ac8c052278e24e8c112956d76c9
LIBRETRO_PROSYSTEM_SITE = $(call github,libretro,prosystem-libretro,$(LIBRETRO_PROSYSTEM_VERSION))
LIBRETRO_PROSYSTEM_LICENSE = GPLv2

LIBRETRO_PROSYSTEM_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_PROSYSTEM_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-prosystem

LIBRETRO_PROSYSTEM_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
LIBRETRO_PROSYSTEM_PLATFORM = armv

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
LIBRETRO_PROSYSTEM_PLATFORM = rpi3_64

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
LIBRETRO_PROSYSTEM_PLATFORM = rpi4

else ifeq ($(BR2_aarch64),y)
LIBRETRO_PROSYSTEM_PLATFORM = unix
endif

define LIBRETRO_PROSYSTEM_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_PROSYSTEM_PLATFORM)"
endef

define LIBRETRO_PROSYSTEM_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_PROSYSTEM_PKG_DIR)$(LIBRETRO_PROSYSTEM_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/prosystem_libretro.so \
	$(LIBRETRO_PROSYSTEM_PKG_DIR)$(LIBRETRO_PROSYSTEM_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_PROSYSTEM_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-prosystem/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_PROSYSTEM_POST_INSTALL_TARGET_HOOKS = LIBRETRO_PROSYSTEM_MAKEPKG

$(eval $(generic-package))
