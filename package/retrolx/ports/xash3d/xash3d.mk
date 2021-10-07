################################################################################
#
# XASH3D
#
################################################################################
# Version.: 20211005
XASH3D_VERSION = 20211005
XASH3D_DEPENDENCIES = xash3d-fwgs hlsdk-xash3d hlsdk-xash3d-opfor hlsdk-xash3d-dmc

XASH3D_PKG_DIR = $(TARGET_DIR)/opt/retrolx/xash3d
XASH3D_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/xash3d

define XASH3D_BUILD_CMDS
endef

define XASH3D_INSTALL_TARGET_CMDS
endef

define XASH3D_MAKEPKG
	# Tidy up package
	mv $(XASH3D_PKG_DIR)$(XASH3D_PKG_INSTALL_DIR)/lib/xash3d/* $(XASH3D_PKG_DIR)$(XASH3D_PKG_INSTALL_DIR)/
	rm -Rf $(XASH3D_PKG_DIR)$(XASH3D_PKG_INSTALL_DIR)/lib/
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/xash3d/*.py $(XASH3D_PKG_DIR)$(XASH3D_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(XASH3D_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/xash3d/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

XASH3D_POST_INSTALL_TARGET_HOOKS = XASH3D_MAKEPKG


$(eval $(virtual-package))
