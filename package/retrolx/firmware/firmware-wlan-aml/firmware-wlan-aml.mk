################################################################################
#
# firmware-wlan-aml
#
################################################################################

FIRMWARE_WLAN_AML_VERSION = dd00e1ec46cab50ab915cd23ce15369f7459d722
FIRMWARE_WLAN_AML_SITE = $(call github,retrolx,brcmfmac_sdio-firmware,$(FIRMWARE_WLAN_AML_VERSION))

FIRMWARE_WLAN_AML_TARGET_DIR=$(TARGET_DIR)/lib/firmware/brcm

define FIRMWARE_WLAN_AML_INSTALL_TARGET_CMDS
	mkdir -p $(FIRMWARE_WLAN_AML_TARGET_DIR)
	cp -r $(@D)/* $(FIRMWARE_WLAN_AML_TARGET_DIR)/
endef

$(eval $(generic-package))
