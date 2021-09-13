################################################################################
#
# BEETLE_NGP
#
################################################################################
# Version.: Commits on Sep 11, 2021
LIBRETRO_BEETLE_NGP_VERSION = fa12533575f77c2946f21999b0c1a4737dfb1e58
LIBRETRO_BEETLE_NGP_SITE = $(call github,libretro,beetle-ngp-libretro,$(LIBRETRO_BEETLE_NGP_VERSION))
LIBRETRO_BEETLE_NGP_LICENSE = GPLv2

LIBRETRO_BEETLE_NGP_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_BEETLE_NGP_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-beetle-ngp

define LIBRETRO_BEETLE_NGP_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_BEETLE_NGP_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_BEETLE_NGP_PKG_DIR)$(LIBRETRO_BEETLE_NGP_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/mednafen_ngp_libretro.so \
	$(LIBRETRO_BEETLE_NGP_PKG_DIR)$(LIBRETRO_BEETLE_NGP_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_BEETLE_NGP_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-beetle-ngp/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_BEETLE_NGP_POST_INSTALL_TARGET_HOOKS = LIBRETRO_BEETLE_NGP_MAKEPKG

$(eval $(generic-package))
