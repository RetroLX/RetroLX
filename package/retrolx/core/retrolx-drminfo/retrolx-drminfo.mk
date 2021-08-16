################################################################################
#
# drminfo
#
################################################################################
# Version.: Commits on May 27, 2020
RETROLX_DRMINFO_VERSION = 1
RETROLX_DRMINFO_SOURCE =
RETROLX_DRMINFO_LICENSE = GPLv3+
RETROLX_DRMINFO_DEPENDENCIES = libdrm

define RETROLX_DRMINFO_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_CC) -I$(STAGING_DIR)/usr/include/drm -ldrm $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-drminfo/batocera-drminfo.c -o $(@D)/batocera-drminfo
endef

define RETROLX_DRMINFO_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/batocera-drminfo $(TARGET_DIR)/usr/bin/batocera-drminfo
endef

$(eval $(generic-package))
