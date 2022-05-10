################################################################################
#
# FUSE
#
################################################################################
# Version.: Commits on Apr 25, 2022
LIBRETRO_FUSE_VERSION = 4269f1507469429dad8cff136bb0a535e7b7f1ef
LIBRETRO_FUSE_SITE = $(call github,libretro,fuse-libretro,$(LIBRETRO_FUSE_VERSION))
LIBRETRO_FUSE_LICENSE = GPLv3

LIBRETRO_FUSE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_FUSE_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-fuse

LIBRETRO_FUSE_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI1),y)
LIBRETRO_FUSE_PLATFORM = rpi1

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI2),y)
LIBRETRO_FUSE_PLATFORM = rpi2

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
LIBRETRO_FUSE_PLATFORM = rpi3_64

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
LIBRETRO_FUSE_PLATFORM = rpi4_64
endif

define LIBRETRO_FUSE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile.libretro platform="$(LIBRETRO_FUSE_PLATFORM)"
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
