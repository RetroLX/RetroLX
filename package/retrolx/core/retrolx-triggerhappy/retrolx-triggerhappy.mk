################################################################################
#
# batocera triggerhappy
#
################################################################################

RETROLX_TRIGGERHAPPY_VERSION = 2
RETROLX_TRIGGERHAPPY_LICENSE = GPL
RETROLX_TRIGGERHAPPY_DEPENDENCIES = triggerhappy # to erase the trigger happy S50 startup script
RETROLX_TRIGGERHAPPY_SOURCE=

define RETROLX_TRIGGERHAPPY_INSTALL_CONFIG
	mkdir -p $(TARGET_DIR)/etc/triggerhappy/triggers.d
	mkdir -p $(TARGET_DIR)/etc/init.d
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-triggerhappy/conf/multimedia_keys.conf          $(TARGET_DIR)/etc/triggerhappy/triggers.d
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-triggerhappy/conf/multimedia_keys_disabled.conf $(TARGET_DIR)/etc/triggerhappy/triggers.d
	install -m 0755 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-triggerhappy/triggerhappy.service  $(TARGET_DIR)/etc/init.d/S50triggerhappy
endef

define RETROLX_TRIGGERHAPPY_INSTALL_RK3326_CONFIG
	mkdir -p $(TARGET_DIR)/etc/triggerhappy/triggers.d
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-triggerhappy/conf/multimedia_keys_Hardkernel_ODROID_GO3.conf $(TARGET_DIR)/etc/triggerhappy/triggers.d
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-triggerhappy/conf/multimedia_keys_Anbernic_RG351P.conf       $(TARGET_DIR)/etc/triggerhappy/triggers.d

	# erase because some models are missing
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-triggerhappy/conf/multimedia_keys_odroidgoadvance.conf       $(TARGET_DIR)/etc/triggerhappy/triggers.d/multimedia_keys.conf

	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/core/retrolx-triggerhappy/conf/multimedia_keys_gameforce.conf       $(TARGET_DIR)/etc/triggerhappy/triggers.d/multimedia_keys.conf
endef

RETROLX_TRIGGERHAPPY_POST_INSTALL_TARGET_HOOKS += RETROLX_TRIGGERHAPPY_INSTALL_CONFIG

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3326),y)
	RETROLX_TRIGGERHAPPY_POST_INSTALL_TARGET_HOOKS += RETROLX_TRIGGERHAPPY_INSTALL_RK3326_CONFIG
endif

$(eval $(generic-package))
