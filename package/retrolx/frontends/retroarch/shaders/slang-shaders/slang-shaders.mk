################################################################################
#
# SLANG SHADERS
#
################################################################################
# Version.: Commits on Mar 5, 2022
SLANG_SHADERS_VERSION = 5dae9be43f8832be609aade33da79076425bb531
SLANG_SHADERS_SITE = $(call github,libretro,slang-shaders,$(SLANG_SHADERS_VERSION))
SLANG_SHADERS_LICENSE = GPL

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
