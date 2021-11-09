################################################################################
#
# HURRICAN
#
################################################################################
# Version.: Commits on Jul 30, 2021
HURRICAN_VERSION = f2cce99acebd1b155cbb445c26e77785a14287d6
HURRICAN_SITE = https://github.com/drfiemost/Hurrican.git

HURRICAN_DEPENDENCIES = sdl2 sdl2_mixer sdl2_image libepoxy
HURRICAN_SITE_METHOD=git
HURRICAN_GIT_SUBMODULES=YES
HURRICAN_LICENSE = GPL-2.0

HURRICAN_PKG_DIR = $(TARGET_DIR)/opt/retrolx/hurrican
HURRICAN_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/hurrican

# Install into package prefix
HURRICAN_INSTALL_TARGET_OPTS = DESTDIR="$(HURRICAN_PKG_DIR)$(HURRICAN_PKG_INSTALL_DIR)" install

HURRICAN_SUPPORTS_IN_SOURCE_BUILD = NO

HURRICAN_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release $(@D)/Hurrican -DRENDERER=GLES2

define HURRICAN_MAKEPKG
	# Copy data
	#mkdir -p $(TARGET_DIR)/usr/share/hurrican/
	#cp -pvr $(@D)/buildroot-build/hurrican $(TARGET_DIR)/usr/bin
	#chmod 0755 $(TARGET_DIR)/usr/bin/hurrican
	#cp -avr $(@D)/Hurrican/data $(TARGET_DIR)/usr/share/hurrican
	#cp -avr $(@D)/Hurrican/lang $(TARGET_DIR)/usr/share/hurrican/

	# Tidy up package
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/hurrican/*.py $(HURRICAN_PKG_DIR)$(HURRICAN_PKG_INSTALL_DIR)
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/hurrican/hurrican.keys $(TARGET_DIR)/usr/share/evmapy

	# Build Pacman package
	cd $(HURRICAN_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/hurrican/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

HURRICAN_POST_INSTALL_TARGET_HOOKS = HURRICAN_MAKEPKG

$(eval $(cmake-package))
