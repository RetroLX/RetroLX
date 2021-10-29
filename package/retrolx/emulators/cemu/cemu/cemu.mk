################################################################################
#
# Cemu
#
################################################################################

# version 1.25.6
CEMU_VERSION = 1.25.6
CEMU_SOURCE = cemu_$(CEMU_VERSION).zip
CEMU_SITE = https://cemu.info/releases

define CEMU_EXTRACT_CMDS
	mkdir -p $(@D) && cd $(@D) && unzip -x $(DL_DIR)/$(CEMU_DL_SUBDIR)/$(CEMU_SOURCE)
endef

define CEMU_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/cemu/
	cp -prn $(@D)/cemu_$(CEMU_VERSION)/{Cemu.exe,gameProfiles,resources} $(TARGET_DIR)/usr/cemu/

	# keys.txt
	mkdir -p $(TARGET_DIR)/usr/share/retrolx/datainit/bios/cemu
	touch $(TARGET_DIR)/usr/share/retrolx/datainit/bios/cemu/keys.txt

	#evmap config
	mkdir -p $(TARGET_DIR)/usr/share/evmapy
	cp -prn $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/cemu/cemu/wiiu.keys $(TARGET_DIR)/usr/share/evmapy

endef

$(eval $(generic-package))
