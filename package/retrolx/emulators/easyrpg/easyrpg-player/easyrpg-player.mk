################################################################################
#
# EASYRPG_PLAYER
#
################################################################################
# Version.: Release on Oct 30, 2021
EASYRPG_PLAYER_VERSION = 0.7.0
EASYRPG_PLAYER_DEPENDENCIES = sdl2 zlib fmt libpng freetype mpg123 libvorbis opusfile sdl2_mixer liblcf pixman speexdsp libxmp wildmidi
EASYRPG_PLAYER_LICENSE = MIT
EASYRPG_PLAYER_SITE = $(call github,EasyRPG,Player,$(EASYRPG_PLAYER_VERSION))

EASYRPG_PLAYER_PKG_DIR = $(TARGET_DIR)/opt/retrolx/easyrpg-player
EASYRPG_PLAYER_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/easyrpg-player

EASYRPG_PLAYER_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
EASYRPG_PLAYER_CONF_OPTS += -DPLAYER_BUILD_EXECUTABLE=ON

EASYRPG_PLAYER_CONF_ENV += LDFLAGS=-lpthread SYSROOT="$(STAGING_DIR)"

# Should be set when the package cannot be built inside the source tree but needs a separate build directory.
EASYRPG_PLAYER_SUPPORTS_IN_SOURCE_BUILD = NO

define EASYRPG_PLAYER_INSTALL_TARGET_CMDS
	echo "EasyRPG Player built as pacman package, no rootfs install"
endef

define EASYRPG_PLAYER_MAKEPKG
	# Create directory
	mkdir -p $(EASYRPG_PLAYER_PKG_DIR)$(EASYRPG_PLAYER_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/buildroot-build/easyrpg-player $(EASYRPG_PLAYER_PKG_DIR)$(EASYRPG_PLAYER_PKG_INSTALL_DIR)
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/easyrpg/easyrpg-player/easyrpg.easyrpg.keys $(EASYRPG_PLAYER_PKG_DIR)$(EASYRPG_PLAYER_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(EASYRPG_PLAYER_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/easyrpg/easyrpg-player/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

EASYRPG_PLAYER_POST_INSTALL_TARGET_HOOKS += EASYRPG_PLAYER_MAKEPKG


$(eval $(cmake-package))
