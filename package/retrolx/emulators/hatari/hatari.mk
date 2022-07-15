################################################################################
#
# HATARI
#
################################################################################
# Version.: Release on Jul 11, 2022
HATARI_VERSION = v2.4.0
HATARI_SOURCE = hatari-$(HATARI_VERSION).tar.gz
HATARI_SITE = $(call github,hatari,hatari,$(HATARI_VERSION))
HATARI_LICENSE = GPLv3
HATARI_DEPENDENCIES = sdl2 zlib libpng libcapsimage

HATARI_PKG_DIR = $(TARGET_DIR)/opt/retrolx/hatari
HATARI_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/hatari

HATARI_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF
HATARI_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
HATARI_CONF_OPTS += -DCAPSIMAGE_INCLUDE_DIR="($STAGING_DIR)/usr/include/caps"

define HATARI_INSTALL_TARGET_CMDS
#	$(INSTALL) -D $(@D)/src/hatari $(TARGET_DIR)/usr/bin/hatari
#       mkdir -p $(TARGET_DIR)/usr/share/hatari
endef

define HATARI_MAKEPKG
	# Create directories
	mkdir -p $(HATARI_PKG_DIR)$(HATARI_PKG_INSTALL_DIR)/data

	# Copy package files
	cp -pr $(@D)/src/hatari $(HATARI_PKG_DIR)$(HATARI_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(HATARI_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/hatari/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

HATARI_POST_INSTALL_TARGET_HOOKS = HATARI_MAKEPKG

$(eval $(cmake-package))
