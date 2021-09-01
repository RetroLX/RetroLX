################################################################################
#
# EmulationStation theme "Carbon"
#
################################################################################
# Version.: Commits on Aug 31, 2021
ES_THEME_CARBON_VERSION = 9d32f6c88ddebd50da7295e8269b5cc5bf1600d5
ES_THEME_CARBON_SITE = $(call github,fabricecaruso,es-theme-carbon,$(ES_THEME_CARBON_VERSION))

define ES_THEME_CARBON_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/usr/share/emulationstation/themes/es-theme-carbon
    cp -r $(@D)/* $(TARGET_DIR)/usr/share/emulationstation/themes/es-theme-carbon
endef

$(eval $(generic-package))
