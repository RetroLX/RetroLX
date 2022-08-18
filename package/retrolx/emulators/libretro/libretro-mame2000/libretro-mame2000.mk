################################################################################
#
# MAME2000
#
################################################################################
# Version.: Commits on Jul 26, 2022
LIBRETRO_MAME2000_VERSION = 0208517404e841fce0c094f1a2776a0e1c6c101d
LIBRETRO_MAME2000_SITE = $(call github,libretro,mame2000-libretro,$(LIBRETRO_MAME2000_VERSION))
LIBRETRO_MAME2000_LICENSE = MAME

LIBRETRO_MAME2000_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_MAME2000_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-mame2000

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
	cd $(LIBRETRO_MAME2000_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-mame2000/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_MAME2000_POST_INSTALL_TARGET_HOOKS = LIBRETRO_MAME2000_MAKEPKG

$(eval $(generic-package))
