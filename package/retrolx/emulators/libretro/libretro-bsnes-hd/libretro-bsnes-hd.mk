################################################################################
#
# BSNES-HD
#
################################################################################
# Version.: Commits on Mar 30, 2021
LIBRETRO_BSNES_HD_VERSION = 0fd18e0f5767284fd373aebd75b00b5bab0d44a9
LIBRETRO_BSNES_HD_SITE = $(call github,DerKoun,bsnes-hd,$(LIBRETRO_BSNES_HD_VERSION))
LIBRETRO_BSNES_HD_LICENSE = GPLv3

LIBRETRO_BSNES_HD_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_BSNES_HD_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-bsnes-hd


define LIBRETRO_BSNES_HD_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/bsnes -f GNUmakefile target="libretro" platform=linux local=false
endef

define LIBRETRO_BSNES_HD_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_GAMBATTE_PKG_DIR)$(LIBRETRO_GAMBATTE_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/bsnes/out/bsnes_hd_beta_libretro.so \
	$(LIBRETRO_BSNES_HD_PKG_DIR)$(LIBRETRO_BSNES_HD_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_BSNES_HD_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-bsnes-hd/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_BSNES_HD_POST_INSTALL_TARGET_HOOKS = LIBRETRO_BSNES_HD_MAKEPKG

$(eval $(generic-package))
