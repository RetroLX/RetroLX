################################################################################
#
# Batocera Retroachievements sounds
#
################################################################################

define RETROLX_RETROACHIEVEMENTS_SOUNDS_INSTALL_TARGET_CMDS
	mkdir -p $(RETROLX_RETROARCH_PKG_DIR)$(RETROLX_RETROARCH_PKG_INSTALL_DIR)/usr/share/libretro/assets/sounds/
	cp -r $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/frontends/retrolx-retroarch/retrolx-retroachievements-sounds/sounds/*.ogg \
	      $(RETROLX_RETROARCH_PKG_DIR)$(RETROLX_RETROARCH_PKG_INSTALL_DIR)/usr/share/libretro/assets/sounds/
endef

$(eval $(generic-package))
