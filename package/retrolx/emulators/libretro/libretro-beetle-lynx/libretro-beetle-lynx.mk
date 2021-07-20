################################################################################
#
# BEETLE_LYNX
#
################################################################################
# Version.: Commits on Mar 24, 2021
LIBRETRO_BEETLE_LYNX_VERSION = 26cb625d1f1c27137ce8069d155231f5a5c68bda
LIBRETRO_BEETLE_LYNX_SITE = $(call github,libretro,beetle-lynx-libretro,$(LIBRETRO_BEETLE_LYNX_VERSION))
LIBRETRO_BEETLE_LYNX_LICENSE = GPLv2

LIBRETRO_BEETLE_LYNX_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_BEETLE_LYNX_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-beetle-lynx

define LIBRETRO_BEETLE_LYNX_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_BEETLE_LYNX_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_BEETLE_LYNX_PKG_DIR)$(LIBRETRO_BEETLE_LYNX_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/mednafen_lynx_libretro.so \
	$(LIBRETRO_BEETLE_LYNX_PKG_DIR)$(LIBRETRO_BEETLE_LYNX_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_BEETLE_LYNX_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-beetle-lynx/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_BEETLE_LYNX_POST_INSTALL_TARGET_HOOKS = LIBRETRO_BEETLE_LYNX_MAKEPKG

$(eval $(generic-package))
