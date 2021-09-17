################################################################################
#
# CAP32
#
################################################################################
# Version.: Commits on Sep 13, 2021
LIBRETRO_CAP32_VERSION = c0dc3a5b1f5fa04d2f5c263445de14f8c8d5b1ed
LIBRETRO_CAP32_SITE = $(call github,libretro,libretro-cap32,$(LIBRETRO_CAP32_VERSION))
LIBRETRO_CAP32_LICENSE = GPLv2

LIBRETRO_CAP32_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_CAP32_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-cap32

LIBRETRO_CAP32_PLATFORM = $(LIBRETRO_PLATFORM)

# retrolx this code needs to be revised, it is not suitable anymore
ifeq ($(BR2_cortex_a35)$(BR2_cortex_a53)$(BR2_arm),yy)
LIBRETRO_CAP32_PLATFORM = armv neon
endif

define LIBRETRO_CAP32_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_CAP32_PLATFORM)"
endef

define LIBRETRO_CAP32_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_CAP32_PKG_DIR)$(LIBRETRO_CAP32_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/cap32_libretro.so \
	$(LIBRETRO_CAP32_PKG_DIR)$(LIBRETRO_CAP32_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_CAP32_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-cap32/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_CAP32_POST_INSTALL_TARGET_HOOKS = LIBRETRO_CAP32_MAKEPKG

$(eval $(generic-package))
