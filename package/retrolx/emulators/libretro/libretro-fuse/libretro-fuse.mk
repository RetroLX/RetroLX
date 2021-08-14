################################################################################
#
# FUSE
#
################################################################################
# Version.: Commits on Aug 3, 2021
LIBRETRO_FUSE_VERSION = 5f331e9772d305ba5209db0910b1963b9d0974c0
LIBRETRO_FUSE_SITE = $(call github,libretro,fuse-libretro,$(LIBRETRO_FUSE_VERSION))
LIBRETRO_FUSE_LICENSE = GPLv3

LIBRETRO_FUSE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_FUSE_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-fuse

define LIBRETRO_FUSE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile.libretro platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_FUSE_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_FUSE_PKG_DIR)$(LIBRETRO_FUSE_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/fuse_libretro.so \
	$(LIBRETRO_FUSE_PKG_DIR)$(LIBRETRO_FUSE_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_FUSE_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-fuse/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_FUSE_POST_INSTALL_TARGET_HOOKS = LIBRETRO_FUSE_MAKEPKG

$(eval $(generic-package))
