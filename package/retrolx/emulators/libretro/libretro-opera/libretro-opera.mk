################################################################################
#
# OPERA
#
################################################################################
# Version.: Commits on Apr 09, 2021
LIBRETRO_OPERA_VERSION = 71125d59b62e4f7ba7ccf6367bf217ba2f2d3871
LIBRETRO_OPERA_SITE = $(call github,libretro,opera-libretro,$(LIBRETRO_OPERA_VERSION))
LIBRETRO_OPERA_LICENSE = LGPL/Non-commercial

LIBRETRO_OPERA_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_OPERA_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-opera

LIBRETRO_OPERA_PLATFORM=$(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_EXYNOS5422),y)
	LIBRETRO_OPERA_PLATFORM=unix-odroidxu
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S922X),y)
	LIBRETRO_OPERA_PLATFORM=unix-CortexA73_G12B
endif

define LIBRETRO_OPERA_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ platform="$(LIBRETRO_OPERA_PLATFORM)"
endef

define LIBRETRO_OPERA_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_OPERA_PKG_DIR)$(LIBRETRO_OPERA_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/opera_libretro.so \
	$(LIBRETRO_OPERA_PKG_DIR)$(LIBRETRO_OPERA_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_OPERA_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-opera/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_OPERA_POST_INSTALL_TARGET_HOOKS = LIBRETRO_OPERA_MAKEPKG

$(eval $(generic-package))
