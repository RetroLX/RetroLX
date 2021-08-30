################################################################################
#
# BEETLE_WSWAN
#
################################################################################
# Version.: Commits on Aug 30, 2021
LIBRETRO_BEETLE_WSWAN_VERSION = 9355f252d7d9c58bb6bec4fb209c9636b0a0fa37
LIBRETRO_BEETLE_WSWAN_SITE = $(call github,libretro,beetle-wswan-libretro,$(LIBRETRO_BEETLE_WSWAN_VERSION))
LIBRETRO_BEETLE_WSWAN_LICENSE = GPLv2

LIBRETRO_BEETLE_WSWAN_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_BEETLE_WSWAN_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-beetle-wswan

define LIBRETRO_BEETLE_WSWAN_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_BEETLE_WSWAN_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_BEETLE_WSWAN_PKG_DIR)$(LIBRETRO_BEETLE_WSWAN_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/mednafen_wswan_libretro.so \
	$(LIBRETRO_BEETLE_WSWAN_PKG_DIR)$(LIBRETRO_BEETLE_WSWAN_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_BEETLE_WSWAN_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-beetle-wswan/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_BEETLE_WSWAN_POST_INSTALL_TARGET_HOOKS = LIBRETRO_BEETLE_WSWAN_MAKEPKG

$(eval $(generic-package))
