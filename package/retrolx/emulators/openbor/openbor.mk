################################################################################
#
# OPENBOR
#
################################################################################
# Version.: 20210810
OPENBOR_VERSION = 20210810
OPENBOR_DEPENDENCIES = openbor4432 openbor6330 openbor6412 openbor6510

OPENBOR_PKG_DIR = $(TARGET_DIR)/opt/retrolx/openbor
OPENBOR_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/openbor

define OPENBOR_BUILD_CMDS
endef

define OPENBOR_INSTALL_TARGET_CMDS
endef

define OPENBOR_MAKEPKG
	# Create directories
	mkdir -p $(OPENBOR_PKG_DIR)$(OPENBOR_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(OPENBOR_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/openbor/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

OPENBOR_POST_INSTALL_TARGET_HOOKS = OPENBOR_MAKEPKG


$(eval $(virtual-package))
