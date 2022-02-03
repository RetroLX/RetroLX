################################################################################
#
# RETROARCH ASSETS
#
################################################################################
# Version.:Commits on Jan 29, 2022
RETROARCH_ASSETS_VERSION = 6320719b9977ec99b7b8aa02003997f8e82ff47d
RETROARCH_ASSETS_SITE = $(call github,libretro,retroarch-assets,$(RETROARCH_ASSETS_VERSION))
RETROARCH_ASSETS_LICENSE = GPL

define RETROARCH_ASSETS_INSTALL_TARGET_CMDS
	mkdir -p $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/libretro/assets/xmb
	cp -r $(@D)/menu_widgets $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/libretro/assets
	cp -r $(@D)/ozone $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/libretro/assets
	cp -r $(@D)/rgui $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/libretro/assets
	cp -r $(@D)/glui $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/libretro/assets
	cp -r $(@D)/xmb/monochrome $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/libretro/assets/xmb
endef

$(eval $(generic-package))
