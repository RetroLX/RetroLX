################################################################################
#
# LIGHTSPARK
#
################################################################################
# Version.: Commits on Jun 18, 2022
LIGHTSPARK_VERSION = 00e3e2a1aecaed29bd0f4315a4701e1aea1682bc
LIGHTSPARK_SITE = $(call github,lightspark,lightspark,$(LIGHTSPARK_VERSION))
LIGHTSPARK_LICENSE = LGPLv3
LIGHTSPARK_DEPENDENCIES = sdl2 sdl2_mixer freetype pcre jpeg libpng cairo ffmpeg libcurl

LIGHTSPARK_PKG_DIR = $(TARGET_DIR)/opt/retrolx/lightspark
LIGHTSPARK_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lightspark

LIGHTSPARK_CONF_OPTS += -DENABLE_RTMP=FALSE -DCOMPILE_NPAPI_PLUGIN=FALSE -DCOMPILE_PPAPI_PLUGIN=FALSE
ifeq ($(BR2_x86_64),y)
else
LIGHTSPARK_CONF_OPTS += -DENABLE_GLES2=TRUE -DCMAKE_C_FLAGS=-DEGL_NO_X11 -DCMAKE_CXX_FLAGS=-DEGL_NO_X11
endif

define LIGHTSPARK_INSTALL_TARGET_CMDS
	echo "LightSpark is built as a Pacman package, skip rootfs install"
endef

define LIGHTSPARK_MAKEPKG
	# Create package directory
	mkdir -p $(LIGHTSPARK_PKG_DIR)$(LIGHTSPARK_PKG_INSTALL_DIR)

	# Copy package files
	cp -pr $(@D)/$(BR2_ARCH)/Release/bin/lightspark $(LIGHTSPARK_PKG_DIR)$(LIGHTSPARK_PKG_INSTALL_DIR)/lightspark
	cp -pr $(@D)/$(BR2_ARCH)/Release/lib/*          $(LIGHTSPARK_PKG_DIR)$(LIGHTSPARK_PKG_INSTALL_DIR)/
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/flash/lightspark/*.py $(LIGHTSPARK_PKG_DIR)$(LIGHTSPARK_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIGHTSPARK_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/flash/lightspark/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIGHTSPARK_POST_INSTALL_TARGET_HOOKS = LIGHTSPARK_MAKEPKG

$(eval $(cmake-package))
