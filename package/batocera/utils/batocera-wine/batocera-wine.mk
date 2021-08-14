################################################################################
#
# batocera wine
#
################################################################################

RETROLX_WINE_VERSION = 1.0
RETROLX_WINE_LICENSE = GPL
RETROLX_WINE_SOURCE=

define RETROLX_WINE_INSTALL_TARGET_CMDS
	install -m 0755 $(BR2_EXTERNAL_RETROLX_PATH)/package/batocera/utils/batocera-wine/batocera-wine $(TARGET_DIR)/usr/bin/batocera-wine
	install -m 0755 $(BR2_EXTERNAL_RETROLX_PATH)/package/batocera/utils/batocera-wine/bsod.py       $(TARGET_DIR)/usr/bin/bsod-wine
	ln -fs /userdata/system/99-nvidia.conf $(TARGET_DIR)/etc/X11/xorg.conf.d/99-nvidia.conf

	mkdir -p $(TARGET_DIR)/usr/share/evmapy
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/batocera/utils/batocera-wine/mugen.keys $(TARGET_DIR)/usr/share/evmapy
endef

$(eval $(generic-package))
