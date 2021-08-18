################################################################################
#
# batocera bezel
#
################################################################################
# Version.: Commits on Jul 8, 2021
RETROLX_BEZEL_VERSION = 95798f5248a5b44faabe983ed0c0ec88ef2e09f4
RETROLX_BEZEL_SITE = $(call github,batocera-linux,batocera-bezel,$(RETROLX_BEZEL_VERSION))

define RETROLX_BEZEL_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/retrolx/datainit/decorations
	cp -r $(@D)/ambiance_broadcast 	      $(TARGET_DIR)/usr/share/retrolx/datainit/decorations
	cp -r $(@D)/ambiance_gameroom 	      $(TARGET_DIR)/usr/share/retrolx/datainit/decorations
	cp -r $(@D)/ambiance_monitor_1084s    $(TARGET_DIR)/usr/share/retrolx/datainit/decorations
	cp -r $(@D)/ambiance_night 	      $(TARGET_DIR)/usr/share/retrolx/datainit/decorations
	cp -r $(@D)/ambiance_vintage_tv	      $(TARGET_DIR)/usr/share/retrolx/datainit/decorations
	cp -r $(@D)/arcade_1980s  	      $(TARGET_DIR)/usr/share/retrolx/datainit/decorations
	cp -r $(@D)/arcade_1980s_vertical     $(TARGET_DIR)/usr/share/retrolx/datainit/decorations
	cp -r $(@D)/arcade_vertical_default   $(TARGET_DIR)/usr/share/retrolx/datainit/decorations
	cp -r $(@D)/default_unglazed          $(TARGET_DIR)/usr/share/retrolx/datainit/decorations

	(cd $(TARGET_DIR)/usr/share/retrolx/datainit/decorations && ln -sf default_unglazed default) # default bezel

	echo -e "You can find help here to find how to customize decorations: \n" \
		> $(TARGET_DIR)/usr/share/retrolx/datainit/decorations/readme.txt
	echo "https://batocera.org/wiki/doku.php?id=en:customize_decorations_bezels" \
		>> $(TARGET_DIR)/usr/share/retrolx/datainit/decorations/readme.txt
	echo "You can put zip standalone bezels here too." \
		>> $(TARGET_DIR)/usr/share/retrolx/datainit/decorations/readme.txt

endef

$(eval $(generic-package))
