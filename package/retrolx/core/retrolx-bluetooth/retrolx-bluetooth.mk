################################################################################
#
# RETROLX BLUETOOTH
#
################################################################################

RETROLX_BLUETOOTH_VERSION = 2
RETROLX_BLUETOOTH_LICENSE = GPL
RETROLX_BLUETOOTH_SOURCE=

RETROLX_BLUETOOTH_STACK=

ifneq ($(BR2_PACKAGE_RETROLX_RPI_ANY),)
	RETROLX_BLUETOOTH_STACK=bcm921 piscan
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3288),y) # tinkerboard only ??
	RETROLX_BLUETOOTH_STACK=rfkreset rtk115
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3399),y)
	RETROLX_BLUETOOTH_STACK=rfkreset bcm150
endif

define RETROLX_BLUETOOTH_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/init.d/
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-bluetooth/S32bluetooth.template $(TARGET_DIR)/etc/init.d/S32bluetooth
	sed -i -e s+"@INTERNAL_BLUETOOTH_STACK@"+"$(RETROLX_BLUETOOTH_STACK)"+ $(TARGET_DIR)/etc/init.d/S32bluetooth
endef

$(eval $(generic-package))
