################################################################################
#
# Vice Emulation
#
################################################################################
# Version.: Dec 24, 2020
VICE_VERSION = 3.5
VICE_SOURCE = vice-$(VICE_VERSION).tar.gz
VICE_SITE = https://sourceforge.net/projects/vice-emu/files/releases
VICE_LICENSE = GPLv2
VICE_DEPENDENCIES = ffmpeg sdl2 libpng giflib zlib lame alsa-lib jpeg sdl2_image

VICE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/vice
VICE_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/vice
VICE_PREFIX_DIR = /opt/retrolx/vice$(VICE_PKG_INSTALL_DIR)

VICE_CONF_OPTS += --disable-option-checking --disable-pdf-docs --prefix=$(VICE_PREFIX_DIR) --exec-prefix=$(VICE_PREFIX_DIR)

# FFMPEG
VICE_DEPENDENCIES += ffmpeg
VICE_CONF_OPTS += --enable-external-ffmpeg

VICE_CONF_OPTS += --enable-midi
VICE_CONF_OPTS += --enable-lame
VICE_CONF_OPTS += --with-alsa
VICE_CONF_OPTS += --with-zlib
VICE_CONF_OPTS += --with-jpeg
VICE_CONF_OPTS += --with-png
VICE_CONF_OPTS += --without-pulse
VICE_CONF_OPTS += --enable-x64

VICE_CONF_OPTS += --enable-arch=sdl
VICE_CONF_OPTS += --enable-sdlui2
VICE_CONF_OPTS += --disable-debug-gtk3ui
VICE_CONF_OPTS += --disable-native-gtk3ui

VICE_CONF_ENV += LDFLAGS=-lSDL2

define VICE_MAKEPKG
	# Build Pacman package
	cd $(VICE_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/vice/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

VICE_POST_INSTALL_TARGET_HOOKS = VICE_MAKEPKG

$(eval $(autotools-package))
