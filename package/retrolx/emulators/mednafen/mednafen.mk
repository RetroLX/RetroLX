################################################################################
#
# MEDNAFEN
#
################################################################################
# Version.: Release on Jan 20, 2022
MEDNAFEN_VERSION = 1.29.0
MEDNAFEN_SOURCE = mednafen-$(MEDNAFEN_VERSION).tar.xz
MEDNAFEN_SITE = https://mednafen.github.io/releases/files
MEDNAFEN_LICENSE = GPLv3
MEDNAFEN_DEPENDENCIES = sdl2 zlib libpng

MEDNAFEN_PKG_DIR = $(TARGET_DIR)/opt/retrolx/mednafen
MEDNAFEN_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/mednafen
MEDNAFEN_PREFIX_DIR = /opt/retrolx/mednafen$(MEDNAFEN_PKG_INSTALL_DIR)

MEDNAFEN_CONF_OPTS = --disable-ssfplay --prefix=$(MEDNAFEN_PREFIX_DIR) --exec-prefix=$(MEDNAFEN_PREFIX_DIR)

define MEDNAFEN_MAKEPKG
	# Build Pacman package
	cd $(MEDNAFEN_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/mednafen/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

MEDNAFEN_POST_INSTALL_TARGET_HOOKS = MEDNAFEN_MAKEPKG

$(eval $(autotools-package))
