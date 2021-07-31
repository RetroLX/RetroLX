################################################################################
#
# SUPERMODEL
#
################################################################################

SUPERMODEL_VERSION = r862
SUPERMODEL_SITE = https://svn.code.sf.net/p/model3emu/code/trunk
SUPERMODEL_SITE_METHOD=svn
SUPERMODEL_DEPENDENCIES = sdl2 zlib libglew libzip sdl2_net
SUPERMODEL_LICENSE = GPLv3

SUPERMODEL_PKG_DIR = $(TARGET_DIR)/opt/retrolx/supermodel
SUPERMODEL_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/supermodel

define SUPERMODEL_BUILD_CMDS
	cp $(@D)/Makefiles/Makefile.UNIX $(@D)/Makefile
	$(SED) "s|CC = gcc|CC = $(TARGET_CC)|g" $(@D)/Makefile
	$(SED) "s|CXX = g++|CXX = $(TARGET_CXX)|g" $(@D)/Makefile
	$(SED) "s|LD = gcc|LD = $(TARGET_CC)|g" $(@D)/Makefile
	$(SED) "s|sdl2-config|$(STAGING_DIR)/usr/bin/sdl2-config|g" $(@D)/Makefile
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) -f Makefile VERBOSE=1
endef


define SUPERMODEL_LINE_ENDINGS_FIXUP
	# DOS2UNIX Supermodel.ini and Main.cpp - patch system does not support different line endings
	sed -i -E -e "s|\r$$||g" $(@D)/Src/OSD/SDL/Main.cpp
	sed -i -E -e "s|\r$$||g" $(@D)/Src/Inputs/Inputs.cpp
	sed -i -E -e "s|\r$$||g" $(@D)/Src/Graphics/New3D/R3DShaderTriangles.h
endef

SUPERMODEL_PRE_PATCH_HOOKS += SUPERMODEL_LINE_ENDINGS_FIXUP

define SUPERMODEL_MAKEPKG
	# Create directories
	mkdir -p $(SUPERMODEL_PKG_DIR)$(SUPERMODEL_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D -m 0755 $(@D)/bin/supermodel $(SUPERMODEL_PKG_DIR)$(SUPERMODEL_PKG_INSTALL_DIR)/supermodel
	$(INSTALL) -D -m 0644 $(@D)/Config/Games.xml $(SUPERMODEL_PKG_DIR)$(SUPERMODEL_PKG_INSTALL_DIR)/Games.xml
	$(INSTALL) -D -m 0644 $(@D)/Config/Supermodel.ini $(SUPERMODEL_PKG_DIR)$(SUPERMODEL_PKG_INSTALL_DIR)/Supermodel.ini.template
	cp $(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/supermodel/model3.supermodel.keys $(SUPERMODEL_PKG_DIR)$(SUPERMODEL_PKG_INSTALL_DIR)
	cp -pr $(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/supermodel/NVRAM $(SUPERMODEL_PKG_DIR)$(SUPERMODEL_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(SUPERMODEL_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/supermodel/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

SUPERMODEL_POST_INSTALL_TARGET_HOOKS = SUPERMODEL_MAKEPKG

$(eval $(generic-package))
