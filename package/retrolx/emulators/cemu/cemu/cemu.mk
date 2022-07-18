################################################################################
#
# Cemu
#
################################################################################

# version 1.26.2
CEMU_VERSION = 1.26.2
CEMU_SOURCE = cemu_$(CEMU_VERSION).zip
CEMU_SITE = https://cemu.info/releases

CEMU_DEPENDENCIES = cemu-hook cemutil

CEMU_PKG_DIR = $(TARGET_DIR)/opt/retrolx/cemu
CEMU_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/cemu

define CEMU_EXTRACT_CMDS
	mkdir -p $(@D) && cd $(@D) && unzip -x $(DL_DIR)/$(CEMU_DL_SUBDIR)/$(CEMU_SOURCE)
endef

define CEMU_MAKEPKG
	mkdir -p $(CEMU_PKG_DIR)$(CEMU_PKG_INSTALL_DIR)
	cp -prn $(@D)/cemu_$(CEMU_VERSION)/{Cemu.exe,gameProfiles,resources} $(CEMU_PKG_DIR)$(CEMU_PKG_INSTALL_DIR)

	# keys.txt (empty, we cannot distribute it for legal reasons)
	touch $(CEMU_PKG_DIR)$(CEMU_PKG_INSTALL_DIR)/keys.txt

	# evmapy config
	cp -prn $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/cemu/cemu/wiiu.keys $(CEMU_PKG_DIR)$(CEMU_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(CEMU_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/cemu/cemu/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

CEMU_POST_INSTALL_TARGET_HOOKS = CEMU_MAKEPKG

$(eval $(generic-package))
