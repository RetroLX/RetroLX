################################################################################
#
# FHEROES2
#
################################################################################

FHEROES2_VERSION = 0.9.15
FHEROES2_SITE = $(call github,ihhub,fheroes2,$(FHEROES2_VERSION))
FHEROES2_DEPENDENCIES = sdl2 sdl2_image

FHEROES2_PKG_DIR = $(TARGET_DIR)/opt/retrolx/fheroes2
FHEROES2_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/fheroes2

# Install into package prefix
FHEROES2_INSTALL_TARGET_OPTS = DESTDIR="$(FHEROES2_PKG_DIR)$(FHEROES2_PKG_INSTALL_DIR)" install

define FHEROES2_MAKEPKG
	# Build Pacman package
	cd $(FHEROES2_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/fheroes2/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

FHEROES2_POST_INSTALL_TARGET_HOOKS = FHEROES2_MAKEPKG

$(eval $(cmake-package))
