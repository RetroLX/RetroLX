################################################################################
#
# NXENGINE
#
################################################################################
# Version.: Commits on Jul 25, 2022
LIBRETRO_NXENGINE_VERSION = aa32afb8df8461920037bdbbddbff00bf465c6de
LIBRETRO_NXENGINE_SITE = $(call github,libretro,nxengine-libretro,$(LIBRETRO_NXENGINE_VERSION))
LIBRETRO_NXENGINE_LICENSE = GPLv3

LIBRETRO_NXENGINE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_NXENGINE_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-nxengine

LIBRETRO_NXENGINE_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
LIBRETRO_NXENGINE_PLATFORM = armv

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
LIBRETRO_NXENGINE_PLATFORM = rpi3_64

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
LIBRETRO_NXENGINE_PLATFORM = rpi4_64

else ifeq ($(BR2_aarch64),y)
LIBRETRO_NXENGINE_PLATFORM = unix
endif

define LIBRETRO_NXENGINE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_NXENGINE_PLATFORM)"
endef

define LIBRETRO_NXENGINE_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_MRBOOM_PKG_DIR)$(LIBRETRO_MRBOOM_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/nxengine_libretro.so \
	$(LIBRETRO_NXENGINE_PKG_DIR)$(LIBRETRO_NXENGINE_PKG_INSTALL_DIR)/nxengine_libretro.so

	# Build Pacman package
	cd $(LIBRETRO_NXENGINE_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-nxengine/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_NXENGINE_POST_INSTALL_TARGET_HOOKS = LIBRETRO_NXENGINE_MAKEPKG

$(eval $(generic-package))
