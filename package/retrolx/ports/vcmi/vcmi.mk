################################################################################
#
# VCMI
#
################################################################################

VCMI_VERSION = ba7c9d70216f2fd34183a95da4980f3aff78e007
VCMI_SITE = https://github.com/vcmi/vcmi.git
VCMI_SITE_METHOD=git
VCMI_GIT_SUBMODULES=YES
VCMI_DEPENDENCIES = sdl2 sdl2_image sdl2_mixer sdl2_ttf ffmpeg tbb

VCMI_PKG_DIR = $(TARGET_DIR)/opt/retrolx/vcmi
VCMI_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/vcmi

VCMI_CONF_OPTS += -DENABLE_TEST=OFF -DENABLE_MONOLITHIC_INSTALL=ON

# Lua scripting module does not build properly
VCMI_CONF_OPTS += -DENABLE_LUA=OFF

# Launcher requires Qt5
ifeq ($(BR2_PACKAGE_QT5),)
VCMI_CONF_OPTS += -DENABLE_LAUNCHER=OFF
endif

# Install into package prefix
VCMI_INSTALL_TARGET_OPTS = DESTDIR="$(VCMI_PKG_DIR)$(VCMI_PKG_INSTALL_DIR)" install

define VCMI_MAKEPKG
	# Build Pacman package
	cd $(VCMI_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/vcmi/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

VCMI_POST_INSTALL_TARGET_HOOKS = VCMI_MAKEPKG

$(eval $(cmake-package))
