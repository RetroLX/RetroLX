################################################################################
#
# LUTRO
#
################################################################################
# Version Commits on Aug 4, 2022
LIBRETRO_LUTRO_VERSION = e9395ab4549b74670598d811ca8094be513c4c5c
LIBRETRO_LUTRO_SITE = $(call github,libretro,libretro-lutro,$(LIBRETRO_LUTRO_VERSION))
LIBRETRO_LUTRO_LICENSE = MIT

LIBRETRO_LUTRO_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_LUTRO_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-lutro

LIBRETRO_LUTRO_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
LIBRETRO_LUTRO_PLATFORM = armv neon

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3326)$(BR2_arm),yy)
LIBRETRO_LUTRO_PLATFORM = armv neon

else ifeq ($(BR2_aarch64),y)
LIBRETRO_LUTRO_PLATFORM = unix

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
LIBRETRO_LUTRO_PLATFORM = armv neon
endif

define LIBRETRO_LUTRO_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_LUTRO_PLATFORM)"
endef

define LIBRETRO_LUTRO_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_LUTRO_PKG_DIR)$(LIBRETRO_LUTRO_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/lutro_libretro.so \
	$(LIBRETRO_LUTRO_PKG_DIR)$(LIBRETRO_LUTRO_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_LUTRO_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-lutro/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_LUTRO_POST_INSTALL_TARGET_HOOKS = LIBRETRO_LUTRO_MAKEPKG

$(eval $(generic-package))
