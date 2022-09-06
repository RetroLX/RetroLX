################################################################################
#
# BEETLE_PCE_FAST
#
################################################################################
# Version.: Commits on Aug 28, 2022
LIBRETRO_BEETLE_PCE_FAST_VERSION = cc248db4d2f47d0f255fbc1a3c651df4beb3d835
LIBRETRO_BEETLE_PCE_FAST_SITE = $(call github,libretro,beetle-pce-fast-libretro,$(LIBRETRO_BEETLE_PCE_FAST_VERSION))
LIBRETRO_BEETLE_PCE_FAST_LICENSE = GPLv2

LIBRETRO_BEETLE_PCE_FAST_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_BEETLE_PCE_FAST_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-beetle-pce-fast

define LIBRETRO_BEETLE_PCE_FAST_BUILD_CMDS
    $(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_BEETLE_PCE_FAST_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_BEETLE_PCE_FAST_PKG_DIR)$(LIBRETRO_BEETLE_PCE_FAST_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/mednafen_pce_fast_libretro.so \
	$(LIBRETRO_BEETLE_PCE_FAST_PKG_DIR)$(LIBRETRO_BEETLE_PCE_FAST_PKG_INSTALL_DIR)/pce_fast_libretro.so

	# Build Pacman package
	cd $(LIBRETRO_BEETLE_PCE_FAST_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-beetle-pce-fast/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_BEETLE_PCE_FAST_POST_INSTALL_TARGET_HOOKS = LIBRETRO_BEETLE_PCE_FAST_MAKEPKG

$(eval $(generic-package))
