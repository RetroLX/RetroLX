################################################################################
#
# SDLPOP
#
################################################################################
# Version.: Commits on Dec 4, 2021
SDLPOP_VERSION = d7ea0f67bb3c9679119ed7c2b255aef650520ca4
SDLPOP_SITE = $(call github,NagyD,SDLPoP,$(SDLPOP_VERSION))
SDLPOP_SUBDIR = src
SDLPOP_LICENSE = GPLv3
SDLPOP_DEPENDENCIES = sdl2 sdl2_image

SDLPOP_PKG_DIR = $(TARGET_DIR)/opt/retrolx/sdlpop
SDLPOP_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/sdlpop

define SDLPOP_INSTALL_TARGET_CMDS
	echo "SDLPoP built as pacman package, no rootfs install"
endef

define SDLPOP_MAKEPKG
	mkdir -p $(SDLPOP_PKG_DIR)$(SDLPOP_PKG_INSTALL_DIR)/data
	mkdir -p $(SDLPOP_PKG_DIR)$(SDLPOP_PKG_INSTALL_DIR)/configs
	#mkdir -p $(TARGET_DIR)/usr/share/evmapy
	$(INSTALL) -m 0755 $(@D)/prince -D $(SDLPOP_PKG_DIR)$(SDLPOP_PKG_INSTALL_DIR)/SDLPoP
	cp -pr $(@D)/data $(SDLPOP_PKG_DIR)$(SDLPOP_PKG_INSTALL_DIR)
	ln -sf /userdata/system/configs/sdlpop/SDLPoP.ini $(SDLPOP_PKG_DIR)$(SDLPOP_PKG_INSTALL_DIR)/configs/SDLPoP.ini
	ln -sf /userdata/system/configs/sdlpop/SDLPoP.cfg $(SDLPOP_PKG_DIR)$(SDLPOP_PKG_INSTALL_DIR)/configs/SDLPoP.cfg
	ln -sf /userdata/screenshots $(SDLPOP_PKG_DIR)$(SDLPOP_PKG_INSTALL_DIR)/screenshots
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/sdlpop/sdlpop.keys $(SDLPOP_PKG_DIR)$(SDLPOP_PKG_INSTALL_DIR)
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/sdlpop/*.py $(SDLPOP_PKG_DIR)$(SDLPOP_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(SDLPOP_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/sdlpop/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

SDLPOP_POST_INSTALL_TARGET_HOOKS = SDLPOP_MAKEPKG

$(eval $(cmake-package))
