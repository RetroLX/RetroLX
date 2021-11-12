################################################################################
#
# GS+
#
################################################################################
# Version.: Commits on Jan 13, 2021
GSPLUS_VERSION = dc1835d62bb485f69faf3fd50a2550629393ee38
GSPLUS_SITE = $(call github,applemu,gsplus,$(GSPLUS_VERSION))
GSPLUS_LICENSE = GPLv2
GSPLUS_DEPENDENCIES = sdl2 libpcap host-re2c


GSPLUS_PKG_DIR = $(TARGET_DIR)/opt/retrolx/gsplus
GSPLUS_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/gsplus

define GSPLUS_INSTALL_TARGET_CMDS
	echo "GSplus built as package, no rootfs install"
endef

define GSPLUS_MAKEPKG
	# Create directory
	mkdir -p $(GSPLUS_PKG_DIR)$(GSPLUS_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/bin/GSplus $(GSPLUS_PKG_DIR)$(GSPLUS_PKG_INSTALL_DIR)
	$(INSTALL) -D $(@D)/bin/libx_readline.so $(GSPLUS_PKG_DIR)$(GSPLUS_PKG_INSTALL_DIR)
	cp -f $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/gsplus/apple2gs.keys $(GSPLUS_PKG_DIR)$(GSPLUS_PKG_INSTALL_DIR)
	cd $(GSPLUS_PKG_DIR)$(GSPLUS_PKG_INSTALL_DIR) && ln -sf apple2gs.keys apple2.keys

	# Build Pacman package
	cd $(GSPLUS_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/gsplus/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

GSPLUS_POST_INSTALL_TARGET_HOOKS = GSPLUS_MAKEPKG

$(eval $(cmake-package))
