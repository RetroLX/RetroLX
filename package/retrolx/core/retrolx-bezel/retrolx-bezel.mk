################################################################################
#
# batocera bezel
#
################################################################################
# Version.: Commits on Feb 1, 2022
RETROLX_BEZEL_VERSION = 6a64404e9f0008b737c56c12ba53710d30036d6f
RETROLX_BEZEL_SITE = $(call github,batocera-linux,batocera-bezel,$(RETROLX_BEZEL_VERSION))

define RETROLX_BEZEL_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/retrolx/datainit/decorations
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
