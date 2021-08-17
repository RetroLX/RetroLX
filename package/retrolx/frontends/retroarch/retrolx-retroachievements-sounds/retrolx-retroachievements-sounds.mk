################################################################################
#
# Batocera Retroachievements sounds
#
################################################################################

define RETROLX_RETROACHIEVEMENTS_SOUNDS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/libretro/assets/sounds/
	cp -r $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/frontends/retroarch/retrolx-retroachievements-sounds/sounds/*.ogg $(TARGET_DIR)/usr/share/libretro/assets/sounds/
endef

$(eval $(generic-package))
