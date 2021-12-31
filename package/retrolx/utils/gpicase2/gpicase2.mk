################################################################################
#
# gpicase2
#
################################################################################
GPICASE2_VERSION = 1.0
GPICASE2_SOURCE = GPi_Case_2_patch.zip
GPICASE2_SITE = https://support.retroflag.com/Products/GPi_Case_2

define GPICASE2_INSTALL_TARGET_CMDS
	mkdir -p $(BINARIES_DIR)/rpi-firmware/overlays
	cp $(@D)/GPi_Case_2_patch/patch_files/overlays/dpi24.dtbo             $(BINARIES_DIR)/rpi-firmware/overlays/dpi24_gpicase.dtbo
	cp $(@D)/GPi_Case_2_patch/patch_files/overlays/pwm-audio-pi-zero.dtbo $(BINARIES_DIR)/rpi-firmware/overlays/pwm-audio-pi-zero_gpicase.dtbo
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/utils/gpicase/99-gpicase.rules                  $(TARGET_DIR)/etc/udev/rules.d
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/utils/gpicase/retrolx-gpicase-install          $(TARGET_DIR)/usr/bin/retrolx-gpicase-install
endef

define GPICASE2_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(GPICASE2_DL_DIR)/$(GPICASE2_SOURCE)
        mv $(@D)/GPi_Case_2_patch $(@D)/GPi_Case_2_patch_parent
	mv $(@D)/GPi_Case_2_patch_parent/* $(@D)/
	rmdir $(@D)/GPi_Case_2_patch_parent
endef

$(eval $(generic-package))
