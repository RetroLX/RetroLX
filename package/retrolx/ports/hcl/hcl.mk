################################################################################
#
# HYDRACASTLELABYRINTH
#
################################################################################
# Version.: Commits on Sept 12, 2021
HCL_VERSION = e112bdb3185bcb314263543aff87db66795f85ff
HCL_SITE = $(call github,ptitSeb,hydracastlelabyrinth,$(HCL_VERSION))

HCL_DEPENDENCIES = sdl2 sdl2_mixer
HCL_LICENSE = GPL-2.0

HCL_PKG_DIR = $(TARGET_DIR)/opt/retrolx/hcl
HCL_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/hcl

HCL_SUPPORTS_IN_SOURCE_BUILD = NO

# Install into package prefix
HCL_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release -DUSE_SDL2=ON -DCMAKE_INSTALL_PREFIX="$(HCL_PKG_DIR)$(HCL_PKG_INSTALL_DIR)"

define HCL_INSTALL_TARGET_CMDS
	echo "HCL built as package, no rootfs install"
endef

define HCL_MAKEPKG
	# Create package
	mkdir -p $(HCL_PKG_DIR)$(HCL_PKG_INSTALL_DIR)
	cp -pvr $(@D)/data $(HCL_PKG_DIR)$(HCL_PKG_INSTALL_DIR)
	$(INSTALL) -D $(@D)/buildroot-build/hcl $(HCL_PKG_DIR)$(HCL_PKG_INSTALL_DIR)/hcl
	chmod 0754 $(HCL_PKG_DIR)$(HCL_PKG_INSTALL_DIR)/hcl

	# Tidy up package
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/hcl/*.py $(HCL_PKG_DIR)$(HCL_PKG_INSTALL_DIR)
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/hcl/hcl.keys $(HCL_PKG_DIR)$(HCL_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(HCL_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/hcl/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

HCL_POST_INSTALL_TARGET_HOOKS = HCL_MAKEPKG

$(eval $(cmake-package))
