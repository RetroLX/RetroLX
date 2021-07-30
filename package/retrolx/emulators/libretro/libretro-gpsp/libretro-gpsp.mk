################################################################################
#
# GPSP
#
################################################################################
LIBRETRO_GPSP_VERSION = da5ec48982ea4f6d8161c99ccc16693819254835
LIBRETRO_GPSP_SITE = $(call github,libretro,gpsp,$(LIBRETRO_GPSP_VERSION))
LIBRETRO_GPSP_LICENSE = GPLv2

LIBRETRO_GPSP_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_GPSP_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-gpsp

define LIBRETRO_GPSP_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) platform=unix
endef

define LIBRETRO_GPSP_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_GPSP_PKG_DIR)$(LIBRETRO_GPSP_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/gpsp_libretro.so \
	$(LIBRETRO_GPSP_PKG_DIR)$(LIBRETRO_GPSP_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_GPSP_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-gpsp/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_GPSP_POST_INSTALL_TARGET_HOOKS = LIBRETRO_GPSP_MAKEPKG

$(eval $(generic-package))
