################################################################################
#
# SLANG SHADERS
#
################################################################################
# Version.: Commits on Sep 4, 2022
SLANG_SHADERS_VERSION = ec7ca0125da2654f9f740c9a40e5bd0a944bfa35
SLANG_SHADERS_SITE = $(call github,libretro,slang-shaders,$(SLANG_SHADERS_VERSION))
SLANG_SHADERS_LICENSE = GPL
SLANG_SHADERS_DEPENDENCIES += common-shaders glsl-shaders

define SLANG_SHADERS_BUILD_CMDS
endef

define SLANG_SHADERS_INSTALL_TARGET_CMDS
        # Simple copy, remove Makefile / configure
        mkdir -p $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/shaders
        cp -ar -t $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/shaders $(@D)/*
        rm $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/shaders/Makefile
        rm $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/shaders/configure
endef

$(eval $(generic-package))
