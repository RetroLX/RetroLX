################################################################################
#
# xow
#
################################################################################
# Version. Commits on Oct 8, 2021
XOW_VERSION = a396e3fd3f1334e1b9edd011931316ccf15ce431
XOW_SITE = $(call github,medusalix,xow,$(XOW_VERSION))
XOW_DEPENDENCIES = host-libcurl host-cabextract libusb

define XOW_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CC="$(TARGET_CC)" -C  $(@D)
endef

define XOW_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/xow $(TARGET_DIR)/usr/bin/xow
	$(INSTALL) -m 0755 -D $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/controllers/xow/xow-daemon $(TARGET_DIR)/usr/bin/xow-daemon
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/controllers/xow/99-xow.rules $(TARGET_DIR)/etc/udev/rules.d
endef

$(eval $(generic-package))
