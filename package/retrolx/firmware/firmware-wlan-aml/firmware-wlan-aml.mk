################################################################################
#
# firmware-wlan-aml
#
################################################################################

FIRMWARE_WLAN_AML_VERSION = 3ddc301c272f081aa5513c1934f6d530bf80de4a
FIRMWARE_WLAN_AML_SITE = $(call github,libreelec,brcmfmac_sdio-firmware,$(FIRMWARE_WLAN_AML_VERSION))

FIRMWARE_WLAN_AML_TARGET_DIR=$(TARGET_DIR)/lib/firmware/brcm

define FIRMWARE_WLAN_AML_INSTALL_TARGET_CMDS
	mkdir -p $(FIRMWARE_WLAN_AML_TARGET_DIR)
	cp -r $(@D)/* $(FIRMWARE_WLAN_AML_TARGET_DIR)/
endef

$(eval $(generic-package))
