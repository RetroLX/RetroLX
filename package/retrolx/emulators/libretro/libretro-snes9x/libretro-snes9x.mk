################################################################################
#
# SNES9X
#
################################################################################
# Version.: Commits on Apr 14, 2022
LIBRETRO_SNES9X_VERSION = bc65c09c280cb225084099385375d3b513a43455
LIBRETRO_SNES9X_SITE = $(call github,libretro,snes9x,$(LIBRETRO_SNES9X_VERSION))
LIBRETRO_SNES9X_LICENSE = Non-commercial

LIBRETRO_SNES9X_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_SNES9X_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-snes9x

LIBRETRO_SNES9X_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S922X),y)
LIBRETRO_SNES9X_PLATFORM = CortexA73_G12B
else ifeq ($(BR2_aarch64),y)
LIBRETRO_SNES9X_PLATFORM = unix
endif

define LIBRETRO_SNES9X_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/libretro -f Makefile platform="$(LIBRETRO_SNES9X_PLATFORM)"
endef

define LIBRETRO_SNES9X_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_SNES9X_PKG_DIR)$(LIBRETRO_SNES9X_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/libretro/snes9x_libretro.so \
	$(LIBRETRO_SNES9X_PKG_DIR)$(LIBRETRO_SNES9X_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_SNES9X_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-snes9x/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_SNES9X_POST_INSTALL_TARGET_HOOKS = LIBRETRO_SNES9X_MAKEPKG

$(eval $(generic-package))
