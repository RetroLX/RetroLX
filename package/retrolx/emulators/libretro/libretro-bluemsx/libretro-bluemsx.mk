################################################################################
#
# BLUEMSX
#
################################################################################
# Version.: Commits on Feb 13, 2022
LIBRETRO_BLUEMSX_VERSION = 92d0c41b4973854114c7b2d06ab727a266d404c5
LIBRETRO_BLUEMSX_SITE = $(call github,libretro,blueMSX-libretro,$(LIBRETRO_BLUEMSX_VERSION))
LIBRETRO_BLUEMSX_LICENSE = GPLv2

LIBRETRO_BLUEMSX_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_BLUEMSX_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-bluemsx


define LIBRETRO_BLUEMSX_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) -f Makefile.libretro platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_BLUEMSX_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_BLUEMSX_PKG_DIR)$(LIBRETRO_BLUEMSX_PKG_INSTALL_DIR)/bios

	# Copy package files
	$(INSTALL) -D $(@D)/bluemsx_libretro.so \
	$(LIBRETRO_BLUEMSX_PKG_DIR)$(LIBRETRO_BLUEMSX_PKG_INSTALL_DIR)
	cp -pr $(@D)/system/bluemsx/* \
	$(LIBRETRO_BLUEMSX_PKG_DIR)$(LIBRETRO_BLUEMSX_PKG_INSTALL_DIR)/bios

	# Build Pacman package
	cd $(LIBRETRO_BLUEMSX_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-bluemsx/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_BLUEMSX_POST_INSTALL_TARGET_HOOKS = LIBRETRO_BLUEMSX_MAKEPKG

$(eval $(generic-package))
