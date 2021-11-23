################################################################################
#
# EmulationStation theme "MiniJawn"
#
################################################################################
# Version.: Commits on Sept 3, 2019
ES_THEME_MINIJAWN_VERSION = cdf15459e757efc088edde3f4ac09a20c8959757
ES_THEME_MINIJAWN_SITE = $(call github,pacdude,es-theme-minijawn,$(ES_THEME_MINIJAWN_VERSION))

ES_THEME_MINIJAWN_PKG_DIR = $(TARGET_DIR)/opt/retrolx/es-theme-minijawn
ES_THEME_MINIJAWN_PKG_INSTALL_DIR = /userdata/themes/es-theme-minijawn

define ES_THEME_MINIJAWN_MAKEPKG
	# Copy data to proper directory
	mkdir -p $(ES_THEME_MINIJAWN_PKG_DIR)$(ES_THEME_MINIJAWN_PKG_INSTALL_DIR)
	cp -r $(@D)/* $(ES_THEME_MINIJAWN_PKG_DIR)$(ES_THEME_MINIJAWN_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(ES_THEME_MINIJAWN_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/frontends/emulationstation/es-theme-minijawn/PKGINFO \
	any $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

ES_THEME_MINIJAWN_POST_INSTALL_TARGET_HOOKS = ES_THEME_MINIJAWN_MAKEPKG

$(eval $(generic-package))
