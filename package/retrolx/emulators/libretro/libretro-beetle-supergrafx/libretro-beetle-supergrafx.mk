################################################################################
#
# BEETLE_SUPERGRAFX
#
################################################################################
# Version.: Commits on Feb 5, 2022
LIBRETRO_BEETLE_SUPERGRAFX_VERSION = ff2330e038856996df0e4354a7f2bef20a4af302
LIBRETRO_BEETLE_SUPERGRAFX_SITE = $(call github,libretro,beetle-supergrafx-libretro,$(LIBRETRO_BEETLE_SUPERGRAFX_VERSION))
LIBRETRO_BEETLE_SUPERGRAFX_LICENSE = GPLv2

LIBRETRO_BEETLE_SUPERGRAFX_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_BEETLE_SUPERGRAFX_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-beetle-supergrafx

define LIBRETRO_BEETLE_SUPERGRAFX_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_BEETLE_SUPERGRAFX_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_BEETLE_SUPERGRAFX_PKG_DIR)$(LIBRETRO_BEETLE_SUPERGRAFX_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/mednafen_supergrafx_libretro.so \
	$(LIBRETRO_BEETLE_SUPERGRAFX_PKG_DIR)$(LIBRETRO_BEETLE_SUPERGRAFX_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_BEETLE_SUPERGRAFX_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-beetle-supergrafx/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_BEETLE_SUPERGRAFX_POST_INSTALL_TARGET_HOOKS = LIBRETRO_BEETLE_SUPERGRAFX_MAKEPKG

$(eval $(generic-package))
