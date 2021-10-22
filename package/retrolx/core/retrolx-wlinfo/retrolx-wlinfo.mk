################################################################################
#
# retrolx-wlinfo
#
################################################################################
# Version.: Commits on Oct 22, 2021
RETROLX_WLINFO_VERSION = 1
RETROLX_WLINFO_SOURCE =
RETROLX_WLINFO_LICENSE = GPLv3+
RETROLX_WLINFO_DEPENDENCIES = wayland

define RETROLX_WLINFO_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_CC) -I$(STAGING_DIR)/usr/include/ -lwayland-client $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-wlinfo/retrolx-wlinfo.c $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-wlinfo/xdg-output-unstable-v1-protocol.c -o $(@D)/retrolx-wlinfo
endef

define RETROLX_WLINFO_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/retrolx-wlinfo $(TARGET_DIR)/usr/bin/retrolx-wlinfo
endef

$(eval $(generic-package))
