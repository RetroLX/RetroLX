################################################################################
#
# Commander Genius
#
################################################################################

CGENIUS_VERSION = v3.1.3
CGENIUS_SITE = $(call github,gerstrong,Commander-Genius,$(CGENIUS_VERSION))

CGENIUS_DEPENDENCIES = sdl2 sdl2_mixer sdl2_image sdl2_ttf boost libcurl

CGENIUS_PKG_DIR = $(TARGET_DIR)/opt/retrolx/cgenius
CGENIUS_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/cgenius

# No OpenGL ES support
ifeq ($(BR2_PACKAGE_RETROLX_IS_X86_ARCH),y)
CGENIUS_CONF_OPTS += -DUSE_OPENGL=ON
else
CGENIUS_CONF_OPTS += -DUSE_OPENGL=OFF -DEMBEDDED=ON
endif

CGENIUS_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF

# Install into package prefix
CGENIUS_INSTALL_TARGET_OPTS = DESTDIR="$(CGENIUS_PKG_DIR)$(CGENIUS_PKG_INSTALL_DIR)" install


define CGENIUS_MAKEPKG
	# Copy shared libraries
	mkdir -p $(CGENIUS_PKG_DIR)$(CGENIUS_PKG_INSTALL_DIR)/usr/lib
	#cp $(@D)/GsKit/base/lua/libGsKit_base_lua.so $(CGENIUS_PKG_DIR)$(CGENIUS_PKG_INSTALL_DIR)/usr/lib
	#cp $(@D)/GsKit/base/utils/property_tree/libGsKit_base_utils_ptree.so $(CGENIUS_PKG_DIR)$(CGENIUS_PKG_INSTALL_DIR)/usr/lib
	#cp $(@D)/GsKit/base/utils/libGsKit_base_utils.so $(CGENIUS_PKG_DIR)$(CGENIUS_PKG_INSTALL_DIR)/usr/lib
	#cp $(@D)/GsKit/base/video/libGsKit_base_video.so $(CGENIUS_PKG_DIR)$(CGENIUS_PKG_INSTALL_DIR)/usr/lib
	#cp $(@D)/GsKit/base/libGsKit_base.so $(CGENIUS_PKG_DIR)$(CGENIUS_PKG_INSTALL_DIR)/usr/lib
	#cp $(@D)/GsKit/fileio/libGsKit_fileio.so $(CGENIUS_PKG_DIR)$(CGENIUS_PKG_INSTALL_DIR)/usr/lib
	#cp $(@D)/GsKit/graphics/libGsKit_graphics.so $(CGENIUS_PKG_DIR)$(CGENIUS_PKG_INSTALL_DIR)/usr/lib
	#cp $(@D)/GsKit/widgets/libGsKit_widgets.so $(CGENIUS_PKG_DIR)$(CGENIUS_PKG_INSTALL_DIR)/usr/lib
	#cp $(@D)/GsKit/libGsKit.so $(CGENIUS_PKG_DIR)$(CGENIUS_PKG_INSTALL_DIR)/usr/lib

	# Tidy up package
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/cgenius/*.py $(CGENIUS_PKG_DIR)$(CGENIUS_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(CGENIUS_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/cgenius/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

CGENIUS_POST_INSTALL_TARGET_HOOKS = CGENIUS_MAKEPKG

$(eval $(cmake-package))
