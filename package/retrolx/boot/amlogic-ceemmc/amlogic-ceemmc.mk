################################################################################
#
# CoreELEC ceemmc tool for Amlogic eMMC install
#
################################################################################

define AMLOGIC_CEEMMC_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/sbin
    	install -m 0755 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/boot/amlogic-ceemmc/ceemmc $(TARGET_DIR)/usr/sbin/ceemmc
endef

$(eval $(generic-package))
