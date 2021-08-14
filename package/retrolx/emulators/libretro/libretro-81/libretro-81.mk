################################################################################
#
# ZX81
#
################################################################################
# Version.: Commits on Mar 11, 2021
LIBRETRO_81_VERSION = 028da99de5a69c1d067eb3f270c0507377c83bb7
LIBRETRO_81_SITE = $(call github,libretro,81-libretro,$(LIBRETRO_81_VERSION))
LIBRETRO_81_LICENSE = GPLv3

LIBRETRO_81_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_81_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-81

LIBRETRO_81_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_aarch64),y)
LIBRETRO_81_PLATFORM = unix
endif

define LIBRETRO_81_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_81_PLATFORM)"
endef

define LIBRETRO_81_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_81_PKG_DIR)$(LIBRETRO_81_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/81_libretro.so \
	$(LIBRETRO_81_PKG_DIR)$(LIBRETRO_81_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_81_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-81/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_81_POST_INSTALL_TARGET_HOOKS = LIBRETRO_81_MAKEPKG

$(eval $(generic-package))
