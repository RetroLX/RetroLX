################################################################################
#
# GS+
#
################################################################################
# Version.: Commits on Jan 13, 2021
GSPLUS_VERSION = dc1835d62bb485f69faf3fd50a2550629393ee38
GSPLUS_SITE = $(call github,applemu,gsplus,$(GSPLUS_VERSION))
GSPLUS_LICENSE = GPLv2
GSPLUS_DEPENDENCIES = sdl2 libpcap host-re2c

define GSPLUS_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/bin/GSplus $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D $(@D)/bin/libx_readline.so $(TARGET_DIR)/usr/lib/
	cp -f $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/gsplus/apple2gs.keys $(TARGET_DIR)/usr/share/evmapy
	cd $(TARGET_DIR)/usr/share/evmapy && ln -sf apple2gs.keys apple2.keys
endef

$(eval $(cmake-package))
