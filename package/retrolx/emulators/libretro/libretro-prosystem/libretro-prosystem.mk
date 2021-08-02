################################################################################
#
# PROSYSTEM
#
################################################################################
# Version.: Commits on Jul 12, 2021
LIBRETRO_PROSYSTEM_VERSION = 30bd65a64fa28623155a94cbbba2444e228157b7
LIBRETRO_PROSYSTEM_SITE = $(call github,libretro,prosystem-libretro,$(LIBRETRO_PROSYSTEM_VERSION))
LIBRETRO_PROSYSTEM_LICENSE = GPLv2

LIBRETRO_PROSYSTEM_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_PROSYSTEM_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-prosystem

LIBRETRO_PROSYSTEM_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S812),y)
LIBRETRO_PROSYSTEM_PLATFORM = armv

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RPI3),y)
LIBRETRO_PROSYSTEM_PLATFORM = rpi3_64

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RPI4),y)
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
	cd $(LIBRETRO_PROSYSTEM_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-prosystem/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_PROSYSTEM_POST_INSTALL_TARGET_HOOKS = LIBRETRO_PROSYSTEM_MAKEPKG

$(eval $(generic-package))