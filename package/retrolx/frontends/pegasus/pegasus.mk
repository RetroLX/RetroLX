################################################################################
#
# Pegasus frontend
#
################################################################################
# Version.: Commits on Sep 25, 2021
PEGASUS_VERSION = weekly_2021w37
PEGASUS_SITE = https://github.com/mmatyas/pegasus-frontend
PEGASUS_SITE_METHOD=git
PEGASUS_GIT_SUBMODULES=YES
PEGASUS_LICENSE = GPLv3
PEGASUS_DEPENDENCIES = qt5base qt5svg qt5gamepad sdl2

PEGASUS_PKG_DIR = $(TARGET_DIR)/opt/retrolx/pegasus
PEGASUS_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/pegasus

#PEGASUS_CONF_OPTS = PREFIX=$(PEGASUS_PKG_DIR)
#PEGASUS_MAKE_OPTS = PREFIX=$(PEGASUS_PKG_DIR)

define PEGASUS_FIX_INSTALL
	mkdir -p $(@D)/tmp-target-install/$(STAGING_DIR)
endef

define PEGASUS_MAKEPKG
	# Create directories
	mkdir -p $(PEGASUS_PKG_DIR)$(PEGASUS_PKG_INSTALL_DIR)

	# Copy package files
	cp -R $(@D)/tmp-target-install/opt/pegasus-frontend/pegasus-fe $(PEGASUS_PKG_DIR)$(PEGASUS_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(PEGASUS_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/frontends/pegasus/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

PEGASUS_PRE_INSTALL_TARGET_HOOKS = PEGASUS_FIX_INSTALL
PEGASUS_POST_INSTALL_TARGET_HOOKS = PEGASUS_MAKEPKG

$(eval $(qmake-package))
