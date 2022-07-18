################################################################################
#
# Cemu-hook
#
################################################################################

CEMU_HOOK_VERSION = 1262d_0577
CEMU_HOOK_SOURCE = cemuhook_$(CEMU_HOOK_VERSION).zip
CEMU_HOOK_SITE = https://files.sshnuke.net

define CEMU_HOOK_EXTRACT_CMDS
	mkdir -p $(@D) && cd $(@D) && unzip -x $(DL_DIR)/$(CEMU_HOOK_DL_SUBDIR)/$(CEMU_HOOK_SOURCE)
endef

define CEMU_HOOK_INSTALL_TARGET_CMDS
	mkdir -p $(CEMU_PKG_DIR)$(CEMU_PKG_INSTALL_DIR)
	cp $(@D)/keystone.dll $(CEMU_PKG_DIR)$(CEMU_PKG_INSTALL_DIR)
	cp $(@D)/cemuhook.dll $(CEMU_PKG_DIR)$(CEMU_PKG_INSTALL_DIR)
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/cemu/cemu-hook/cemuhook.ini $(CEMU_PKG_DIR)$(CEMU_PKG_INSTALL_DIR)
endef

$(eval $(generic-package))
