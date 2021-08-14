################################################################################
#
# BEETLE_VB
#
################################################################################
# Version.: Commits on Jul 18, 2021
LIBRETRO_BEETLE_VB_VERSION = 8a2bb71b6f5350b15c1d2bfb0dc8224445977f36
LIBRETRO_BEETLE_VB_SITE = $(call github,libretro,beetle-vb-libretro,$(LIBRETRO_BEETLE_VB_VERSION))
LIBRETRO_BEETLE_VB_LICENSE = GPLv2

LIBRETRO_BEETLE_VB_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_BEETLE_VB_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-beetle-vb

LIBRETRO_BEETLE_VB_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
LIBRETRO_BEETLE_VB_PLATFORM = rpi3_64

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
LIBRETRO_BEETLE_VB_PLATFORM = rpi4_64

else ifeq ($(BR2_aarch64),y)
LIBRETRO_BEETLE_VB_PLATFORM = unix
endif

define LIBRETRO_BEETLE_VB_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) platform="$(LIBRETRO_BEETLE_VB_PLATFORM)"
endef

define LIBRETRO_BEETLE_VB_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_BEETLE_VB_PKG_DIR)$(LIBRETRO_BEETLE_VB_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/mednafen_vb_libretro.so \
	$(LIBRETRO_BEETLE_VB_PKG_DIR)$(LIBRETRO_BEETLE_VB_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_BEETLE_VB_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-beetle-vb/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_BEETLE_VB_POST_INSTALL_TARGET_HOOKS = LIBRETRO_BEETLE_VB_MAKEPKG

$(eval $(generic-package))
