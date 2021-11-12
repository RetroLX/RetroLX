################################################################################
#
# tic80 - TIC-80 emulator
#
################################################################################
# Version.: Release on Jul 23, 2021
LIBRETRO_TIC80_VERSION = v0.90.1723
LIBRETRO_TIC80_SITE = https://github.com/nesbox/TIC-80.git
LIBRETRO_TIC80_SITE_METHOD=git
LIBRETRO_TIC80_GIT_SUBMODULES=YES

LIBRETRO_TIC80_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_TIC80_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-tic80

LIBRETRO_TIC80_LICENSE = MIT
LIBRETRO_TIC80_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
LIBRETRO_TIC80_PLATFORM = rpi3
endif

LIBRETRO_TIC80_CONF_OPTS += -DBUILD_PLAYER=OFF -DBUILD_SOKOL=OFF -DBUILD_SDL=OFF -DBUILD_DEMO_CARTS=OFF -DBUILD_LIBRETRO=ON

define LIBRETRO_TIC80_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_TIC80_PLATFORM)"
endef

define LIBRETRO_TIC80_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_TIC80_PKG_DIR)$(LIBRETRO_TIC80_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/lib/tic80_libretro.so \
	$(LIBRETRO_TIC80_PKG_DIR)$(LIBRETRO_TIC80_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_TIC80_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-tic80/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_TIC80_POST_INSTALL_TARGET_HOOKS = LIBRETRO_TIC80_MAKEPKG

$(eval $(cmake-package))
