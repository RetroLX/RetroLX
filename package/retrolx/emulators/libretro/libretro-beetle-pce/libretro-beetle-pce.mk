################################################################################
#
# BEETLE_PCE
#
################################################################################
# Version.: Commits on Apr 12, 2021
LIBRETRO_BEETLE_PCE_VERSION = 0a4c18e1622c384813f26c62629542ce8ee78ecf
LIBRETRO_BEETLE_PCE_SITE = $(call github,libretro,beetle-pce-libretro,$(LIBRETRO_BEETLE_PCE_VERSION))
LIBRETRO_BEETLE_PCE_LICENSE = GPLv2

LIBRETRO_BEETLE_PCE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_BEETLE_PCE_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-beetle-pce

define LIBRETRO_BEETLE_PCE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_BEETLE_PCE_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_BEETLE_PCE_PKG_DIR)$(LIBRETRO_BEETLE_PCE_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/mednafen_pce_libretro.so \
	$(LIBRETRO_BEETLE_PCE_PKG_DIR)$(LIBRETRO_BEETLE_PCE_PKG_INSTALL_DIR)/pce_libretro.so

	# Build Pacman package
	cd $(LIBRETRO_BEETLE_PCE_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-beetle-pce/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_BEETLE_PCE_POST_INSTALL_TARGET_HOOKS = LIBRETRO_BEETLE_PCE_MAKEPKG

$(eval $(generic-package))
