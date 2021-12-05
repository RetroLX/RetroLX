################################################################################
#
# firmware-wlan-aml
#
################################################################################

FIRMWARE_WLAN_AML_VERSION = 8c76ac351014e569cba5a2e8dac64f1fa1840080
FIRMWARE_WLAN_AML_SITE = $(call github,retrolx,brcmfmac_sdio-firmware,$(FIRMWARE_WLAN_AML_VERSION))

FIRMWARE_WLAN_AML_TARGET_DIR=$(TARGET_DIR)/lib/firmware/brcm

define FIRMWARE_WLAN_AML_INSTALL_TARGET_CMDS
	mkdir -p $(FIRMWARE_WLAN_AML_TARGET_DIR)
	cp -r $(@D)/* $(FIRMWARE_WLAN_AML_TARGET_DIR)/
endef

$(eval $(generic-package))
