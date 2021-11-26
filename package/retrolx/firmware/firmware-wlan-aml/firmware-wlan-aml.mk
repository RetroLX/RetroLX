################################################################################
#
# firmware-wlan-aml
#
################################################################################

FIRMWARE_WLAN_AML_VERSION = ee28faccfd65c17e1e6afbf103b6a81fa13fe815
FIRMWARE_WLAN_AML_SITE = $(call github,libreelec,brcmfmac_sdio-firmware,$(FIRMWARE_WLAN_AML_VERSION))

FIRMWARE_WLAN_AML_TARGET_DIR=$(TARGET_DIR)/lib/firmware/brcm

define FIRMWARE_WLAN_AML_INSTALL_TARGET_CMDS
	mkdir -p $(FIRMWARE_WLAN_AML_TARGET_DIR)
	cp -r $(@D)/* $(FIRMWARE_WLAN_AML_TARGET_DIR)/
endef

$(eval $(generic-package))
