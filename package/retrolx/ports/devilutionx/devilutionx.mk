################################################################################
#
# devilutionx
#
################################################################################

DEVILUTIONX_VERSION = 1.4.1
DEVILUTIONX_SITE = https://github.com/diasurgical/devilutionX/releases/download/$(DEVILUTIONX_VERSION)
DEVILUTIONX_SOURCE = devilutionx-src.tar.xz
DEVILUTIONX_DEPENDENCIES = sdl2 sdl2_image fmt libsodium bzip2

DEVILUTIONX_PKG_DIR = $(TARGET_DIR)/opt/retrolx/devilutionx
DEVILUTIONX_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/devilutionx

# Should be set when the package cannot be built inside the source tree but needs a separate build directory.
DEVILUTIONX_SUPPORTS_IN_SOURCE_BUILD = NO

# Prefill the player name when creating a new character, in case the device does
# not have a keyboard.
DEVILUTIONX_CONF_OPTS += -DPREFILL_PLAYER_NAME=ON -DNONET=ON -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF

# Ensure that DevilutionX's vendored dependencies are not accidentally fetched from network.
# They should all be present in the source package.
DEVILUTIONX_CONF_OPTS += -DFETCHCONTENT_FULLY_DISCONNECTED=ON

# Install into package prefix
DEVILUTIONX_INSTALL_TARGET_OPTS = DESTDIR="$(DEVILUTIONX_PKG_DIR)$(DEVILUTIONX_PKG_INSTALL_DIR)" install

define DEVILUTIONX_MAKEDIR
	# Create package directory
	mkdir -p $(DEVILUTIONX_PKG_DIR)$(DEVILUTIONX_PKG_INSTALL_DIR)
endef

define DEVILUTIONX_MAKEPKG
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/devilutionx/*.py $(DEVILUTIONX_PKG_DIR)$(DEVILUTIONX_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(DEVILUTIONX_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/devilutionx/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

DEVILUTIONX_POST_INSTALL_TARGET_HOOKS = DEVILUTIONX_MAKEPKG
DEVILUTIONX_PRE_INSTALL_TARGET_HOOKS = DEVILUTIONX_MAKEDIR

$(eval $(cmake-package))
