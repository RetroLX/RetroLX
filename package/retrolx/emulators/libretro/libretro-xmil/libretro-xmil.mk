################################################################################
#
# xmil - Sharp X1 emulator
#
################################################################################
# Version.: Commits on Mar 14, 2021
LIBRETRO_XMIL_VERSION = 4b4227b5098a21914c04fb873d755e4958928305
LIBRETRO_XMIL_SITE_METHOD=git
LIBRETRO_XMIL_SITE=https://github.com/libretro/xmil-libretro
LIBRETRO_XMIL_GIT_SUBMODULES=YES
LIBRETRO_XMIL_LICENSE = BSD-3

LIBRETRO_XMIL_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_XMIL_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-xmil

define LIBRETRO_XMIL_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/libretro -f Makefile platform="unix"
endef

define LIBRETRO_XMIL_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_XMIL_PKG_DIR)$(LIBRETRO_XMIL_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/libretro/x1_libretro.so \
	$(LIBRETRO_XMIL_PKG_DIR)$(LIBRETRO_XMIL_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_XMIL_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-xmil/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_XMIL_POST_INSTALL_TARGET_HOOKS = LIBRETRO_XMIL_MAKEPKG

$(eval $(generic-package))
