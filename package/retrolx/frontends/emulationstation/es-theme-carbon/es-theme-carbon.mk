################################################################################
#
# EmulationStation theme "Carbon"
#
################################################################################
# Version.: Commits on Aug 17, 2022
ES_THEME_CARBON_VERSION = 8f2081bfbc01abc7ceaecb2c13684270452d02cc
ES_THEME_CARBON_SITE = $(call github,fabricecaruso,es-theme-carbon,$(ES_THEME_CARBON_VERSION))

ES_THEME_CARBON_PKG_DIR = $(TARGET_DIR)/opt/retrolx/es-theme-carbon
ES_THEME_CARBON_PKG_INSTALL_DIR = /userdata/themes/es-theme-carbon

define ES_THEME_CARBON_MAKEPKG
	# Copy data to proper directory
	mkdir -p $(ES_THEME_CARBON_PKG_DIR)$(ES_THEME_CARBON_PKG_INSTALL_DIR)
	cp -r $(@D)/* $(ES_THEME_CARBON_PKG_DIR)$(ES_THEME_CARBON_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(ES_THEME_CARBON_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/frontends/emulationstation/es-theme-carbon/PKGINFO \
	any $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

ES_THEME_CARBON_POST_INSTALL_TARGET_HOOKS = ES_THEME_CARBON_MAKEPKG

$(eval $(generic-package))
