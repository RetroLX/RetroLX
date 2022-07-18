################################################################################
#
# CORSIXTH
#
################################################################################

CORSIXTH_VERSION = v0.66
CORSIXTH_SITE = $(call github,CorsixTH,CorsixTH,$(CORSIXTH_VERSION))
CORSIXTH_DEPENDENCIES = sdl2 sdl2_image

CORSIXTH_PKG_DIR = $(TARGET_DIR)/opt/retrolx/corsixth
CORSIXTH_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/corsixth

CORSIXTH_CONF_OPTS += -DWITH_LUAJIT=ON
CORSIXTH_CONF_ENV += LDFLAGS="-lluajit-5.1"

# Install into package prefix
CORSIXTH_INSTALL_TARGET_OPTS = DESTDIR="$(CORSIXTH_PKG_DIR)$(CORSIXTH_PKG_INSTALL_DIR)" install

define CORSIXTH_MAKEPKG
	# Build Pacman package
	cd $(CORSIXTH_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/corsixth/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

CORSIXTH_POST_INSTALL_TARGET_HOOKS = CORSIXTH_MAKEPKG

$(eval $(cmake-package))
