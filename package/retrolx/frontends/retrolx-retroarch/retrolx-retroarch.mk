################################################################################
#
# retroarch
#
################################################################################
# Version.: Release on Oct 9, 2021
RETROLX_RETROARCH_VERSION = v1.9.11-1
RETROLX_RETROARCH_LICENSE = GPLv3+
RETROLX_RETROARCH_DEPENDENCIES = retroarch retroarch-assets common-shaders glsl-shaders slang-shaders

RETROLX_RETROARCH_PKG_DIR = $(TARGET_DIR)/opt/retrolx/retroarch
RETROLX_RETROARCH_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/retroarch

define RETROLX_RETROARCH_BUILD_CMDS
endef

define RETROLX_RETROARCH_INSTALL_TARGET_CMDS
endef

define RETROLX_RETROARCH_MAKEPKG
	# Create directories
	mkdir -p $(RETROLX_RETROARCH_PKG_DIR)$(RETROLX_RETROARCH_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(RETROLX_RETROARCH_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/frontends/retrolx-retroarch/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

RETROLX_RETROARCH_POST_INSTALL_TARGET_HOOKS = RETROLX_RETROARCH_MAKEPKG

$(eval $(virtual-package))
