################################################################################
#
# BSNES
#
################################################################################
# Version.: Commits on Mar 30, 2021
LIBRETRO_BSNES_VERSION = 4ea6208ad05de7698c321db6fffea9273efc7dee
LIBRETRO_BSNES_SITE = $(call github,libretro,bsnes,$(LIBRETRO_BSNES_VERSION))
LIBRETRO_BSNES_LICENSE = GPLv3

LIBRETRO_BSNES_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_BSNES_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-bsnes

define LIBRETRO_BSNES_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/bsnes -f GNUmakefile target="libretro" platform=linux local=false
endef

define LIBRETRO_BSNES_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_BSNES_PKG_DIR)$(LIBRETRO_BSNES_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/bsnes/out/bsnes_libretro.so \
	$(LIBRETRO_BSNES_PKG_DIR)$(LIBRETRO_BSNES_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_BSNES_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-bsnes/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_BSNES_POST_INSTALL_TARGET_HOOKS = LIBRETRO_BSNES_MAKEPKG

$(eval $(generic-package))
