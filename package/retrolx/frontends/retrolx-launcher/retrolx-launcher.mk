################################################################################
#
# RetroLX launcher
#
################################################################################
# Version.: Commits on Jul 9, 2022
RETROLX_LAUNCHER_VERSION = 146767c48f78e901aa5ec3e7ae3979990dcc956b
RETROLX_LAUNCHER_SITE = https://github.com/RetroLX/launcher
RETROLX_LAUNCHER_SITE_METHOD=git
RETROLX_LAUNCHER_GIT_SUBMODULES=YES
RETROLX_LAUNCHER_LICENSE = GPLv3
RETROLX_LAUNCHER_DEPENDENCIES = qt5base qt5svg qt5gamepad sdl2

#RETROLX_LAUNCHER_PKG_DIR = $(TARGET_DIR)/opt/retrolx/launcher
#RETROLX_LAUNCHER_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/launcher

#RETROLX_LAUNCHER_CONF_OPTS = PREFIX=$(RETROLX_LAUNCHER_PKG_DIR)
#RETROLX_LAUNCHER_MAKE_OPTS = PREFIX=$(RETROLX_LAUNCHER_PKG_DIR)

define RETROLX_LAUNCHER_FIX_INSTALL
	mkdir -p $(@D)/tmp-target-install/$(STAGING_DIR)
endef

define RETROLX_LAUNCHER_INSTALL_ROOTFS
	cp $(@D)/tmp-target-install/opt/retrolx-launcher/bin/retrolx-launcher $(TARGET_DIR)/usr/bin
endef

#define RETROLX_LAUNCHER_MAKEPKG
#	# Create directories
#	mkdir -p $(RETROLX_LAUNCHER_PKG_DIR)$(RETROLX_LAUNCHER_PKG_INSTALL_DIR)

#	# Copy package files
#	cp -R $(@D)/tmp-target-install/opt/pegasus-frontend/pegasus-fe $(RETROLX_LAUNCHER_PKG_DIR)$(RETROLX_LAUNCHER_PKG_INSTALL_DIR)

#	# Build Pacman package
#	cd $(RETROLX_LAUNCHER_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
#	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/frontends/launcher/PKGINFO \
#	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
#	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

#	# Cleanup
#	rm -Rf $(TARGET_DIR)/opt/retrolx/*
#endef

RETROLX_LAUNCHER_PRE_INSTALL_TARGET_HOOKS = RETROLX_LAUNCHER_FIX_INSTALL
RETROLX_LAUNCHER_POST_INSTALL_TARGET_HOOKS = RETROLX_LAUNCHER_INSTALL_ROOTFS

$(eval $(qmake-package))
