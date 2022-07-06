################################################################################
#
# RetroFE frontend
#
################################################################################
# Version.: Commits on Mar 27, 2022
RETROFE_VERSION = 2ddd65a76210d241031c4ac9268255f311df25d1
RETROFE_SITE = https://github.com/phulshof/RetroFE
RETROFE_SITE_METHOD=git
RETROFE_LICENSE = GPLv3
RETROFE_DEPENDENCIES = sdl2 sdl2_image sdl2_mixer sdl2_ttf gstreamer1 gst1-plugins-base

RETROFE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/retrofe
RETROFE_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/retrofe

RETROFE_SUBDIR = RetroFE/Source
#RETROFE_CONF_OPTS = 
#-DBUILD_SHARED_LIBS=OFF

define RETROFE_INSTALL_TARGET_CMDS
	cd $(@D) && $(HOST_DIR)/bin/python $(@D)/Scripts/Package.py --os=linux --build=full
endef

define RETROFE_MAKEPKG
	# Create directories
	mkdir -p $(RETROFE_PKG_DIR)$(RETROFE_PKG_INSTALL_DIR)

	# Copy package files
	cp -R $(@D)/Artifacts/linux/RetroFE/* $(RETROFE_PKG_DIR)$(RETROFE_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(RETROFE_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/frontends/retrofe/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

RETROFE_POST_INSTALL_TARGET_HOOKS = RETROFE_MAKEPKG

$(eval $(cmake-package))
