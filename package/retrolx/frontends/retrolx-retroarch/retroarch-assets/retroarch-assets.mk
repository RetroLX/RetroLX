################################################################################
#
# RETROARCH ASSETS
#
################################################################################
# Version.:Commits on Sep 22, 2021
RETROARCH_ASSETS_VERSION = 62b5d18b8141113c55d6db768882dc25b30ace45
RETROARCH_ASSETS_SITE = $(call github,libretro,retroarch-assets,$(RETROARCH_ASSETS_VERSION))
RETROARCH_ASSETS_LICENSE = GPL

define RETROARCH_ASSETS_INSTALL_TARGET_CMDS
	mkdir -p $(RETROLX_RETROARCH_PKG_DIR)$(RETROLX_RETROARCH_PKG_INSTALL_DIR)/usr/share/libretro/assets/xmb
	cp -r $(@D)/menu_widgets $(RETROLX_RETROARCH_PKG_DIR)$(RETROLX_RETROARCH_PKG_INSTALL_DIR)/usr/share/libretro/assets
	cp -r $(@D)/ozone $(RETROLX_RETROARCH_PKG_DIR)$(RETROLX_RETROARCH_PKG_INSTALL_DIR)/usr/share/libretro/assets
	cp -r $(@D)/rgui $(RETROLX_RETROARCH_PKG_DIR)$(RETROLX_RETROARCH_PKG_INSTALL_DIR)/usr/share/libretro/assets
	cp -r $(@D)/glui $(RETROLX_RETROARCH_PKG_DIR)$(RETROLX_RETROARCH_PKG_INSTALL_DIR)/usr/share/libretro/assets
	cp -r $(@D)/xmb/monochrome $(RETROLX_RETROARCH_PKG_DIR)$(RETROLX_RETROARCH_PKG_INSTALL_DIR)/usr/share/libretro/assets/xmb
endef

$(eval $(generic-package))
