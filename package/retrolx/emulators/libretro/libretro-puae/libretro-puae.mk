################################################################################
#
# PUAE
#
################################################################################
# Version.: Commits on Jul 20, 2021
LIBRETRO_PUAE_VERSION = 1ba1fa92df8075010d334bdd9df7a3ae00e3c750
LIBRETRO_PUAE_SITE = $(call github,libretro,libretro-uae,$(LIBRETRO_PUAE_VERSION))
LIBRETRO_PUAE_LICENSE = GPLv2

LIBRETRO_PUAE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_PUAE_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-puae

PUAEPLATFORM=$(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
PUAEPLATFORM=rpi
endif

define LIBRETRO_PUAE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(PUAEPLATFORM)"
endef

define LIBRETRO_PUAE_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_PUAE_PKG_DIR)$(LIBRETRO_PUAE_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/puae_libretro.so \
	$(LIBRETRO_PUAE_PKG_DIR)$(LIBRETRO_PUAE_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_PUAE_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-puae/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_PUAE_POST_INSTALL_TARGET_HOOKS = LIBRETRO_PUAE_MAKEPKG

$(eval $(generic-package))
