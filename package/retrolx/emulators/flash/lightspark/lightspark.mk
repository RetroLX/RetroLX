################################################################################
#
# LIGHTSPARK
#
################################################################################
# Version.: Commits on Dec 30, 2021
LIGHTSPARK_VERSION = 33e890185e9db09009b32a91d690d6f523d018ce
LIGHTSPARK_SITE = $(call github,lightspark,lightspark,$(LIGHTSPARK_VERSION))
LIGHTSPARK_LICENSE = LGPLv3
LIGHTSPARK_DEPENDENCIES = sdl2 sdl2_mixer freetype pcre jpeg libpng cairo ffmpeg libcurl

ifeq ($(BR2_x86_64),y)
else
LIGHTSPARK_CONF_OPTS += -DENABLE_GLES2=TRUE -DENABLE_RTMP=FALSE -DCOMPILE_NPAPI_PLUGIN=FALSE -DCOMPILE_PPAPI_PLUGIN=FALSE -DCMAKE_C_FLAGS=-DEGL_NO_X11 -DCMAKE_CXX_FLAGS=-DEGL_NO_X11
endif

define LIGHTSPARK_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/bin
	mkdir -p $(TARGET_DIR)/usr/lib
	mkdir -p $(TARGET_DIR)/usr/share/evmapy

	cp -pr $(@D)/$(BR2_ARCH)/Release/bin/lightspark $(TARGET_DIR)/usr/bin/lightspark
	cp -pr $(@D)/$(BR2_ARCH)/Release/lib/*          $(TARGET_DIR)/usr/lib/

	# evmap config
	mkdir -p $(TARGET_DIR)/usr/share/evmapy
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/flash/lightspark/flash.lightspark.keys $(TARGET_DIR)/usr/share/evmapy
endef

$(eval $(cmake-package))
