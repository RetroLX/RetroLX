################################################################################
#
# MAME2000
#
################################################################################
# Version.: Commits on May 29, 2021
LIBRETRO_MAME2000_VERSION = 49671d509bd370a1e92b972eb021149fcdfb1a0d
LIBRETRO_MAME2000_SITE = $(call github,libretro,mame2000-libretro,$(LIBRETRO_MAME2000_VERSION))
LIBRETRO_MAME2000_LICENSE = MAME

LIBRETRO_MAME2000_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_MAME2000_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-mame2000

define LIBRETRO_MAME2000_BUILD_CMDS
	mkdir -p $(@D)/obj_libretro_libretro/cpu
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) -f Makefile ARM=1
endef

define LIBRETRO_MAME2000_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_MAME2000_PKG_DIR)$(LIBRETRO_MAME2000_PKG_INSTALL_DIR)/bios/samples

	# Copy package files
	cp -pr $(@D)/mame2000_libretro.so $(LIBRETRO_MAME2000_PKG_DIR)$(LIBRETRO_MAME2000_PKG_INSTALL_DIR)
	cp -pr $(@D)/metadata/* $(LIBRETRO_MAME2000_PKG_DIR)$(LIBRETRO_MAME2000_PKG_INSTALL_DIR)/bios/

	# Build Pacman package
	cd $(LIBRETRO_MAME2000_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-mame2000/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_MAME2000_POST_INSTALL_TARGET_HOOKS = LIBRETRO_MAME2000_MAKEPKG

$(eval $(generic-package))
