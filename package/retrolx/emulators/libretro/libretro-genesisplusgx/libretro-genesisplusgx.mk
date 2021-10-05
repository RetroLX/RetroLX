################################################################################
#
# GENESISPLUSGX
#
################################################################################
# Version.: Commits on Oct 4, 2021
LIBRETRO_GENESISPLUSGX_VERSION = 485358ed09b3352e95ffa983d89607e9a555a697
LIBRETRO_GENESISPLUSGX_SITE = $(call github,ekeeke,Genesis-Plus-GX,$(LIBRETRO_GENESISPLUSGX_VERSION))
LIBRETRO_GENESISPLUSGX_LICENSE = Non-commercial

LIBRETRO_GENESISPLUSGX_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_GENESISPLUSGX_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-genesisplusgx

LIBRETRO_GENESISPLUSGX_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S922X),y)
LIBRETRO_GENESISPLUSGX_PLATFORM += CortexA73_G12B

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_AW32),y)
LIBRETRO_GENESISPLUSGX_PLATFORM += rpi2

endif

define LIBRETRO_GENESISPLUSGX_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) -f Makefile.libretro platform="$(LIBRETRO_GENESISPLUSGX_PLATFORM)"
endef

define LIBRETRO_GENESISPLUSGX_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_GENESISPLUSGX_PKG_DIR)$(LIBRETRO_GENESISPLUSGX_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/genesis_plus_gx_libretro.so \
	$(LIBRETRO_GENESISPLUSGX_PKG_DIR)$(LIBRETRO_GENESISPLUSGX_PKG_INSTALL_DIR)/genesisplusgx_libretro.so

	# Build Pacman package
	cd $(LIBRETRO_GENESISPLUSGX_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-genesisplusgx/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_GENESISPLUSGX_POST_INSTALL_TARGET_HOOKS = LIBRETRO_GENESISPLUSGX_MAKEPKG

$(eval $(generic-package))
