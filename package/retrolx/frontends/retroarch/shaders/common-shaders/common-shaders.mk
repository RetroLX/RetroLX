################################################################################
#
# COMMON SHADERS
#
################################################################################
# Version.: Commits on Feb 26, 2021
COMMON_SHADERS_VERSION = 55e401834b732e62c34411321c4ffd82524345d4
COMMON_SHADERS_SITE = $(call github,libretro,common-shaders,$(COMMON_SHADERS_VERSION))
COMMON_SHADERS_LICENSE = GPL

define COMMON_SHADERS_BUILD_CMDS
endef

define COMMON_SHADERS_INSTALL_TARGET_CMDS
        # Simple copy, remove Makefile / configure
        mkdir -p $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/shaders
	cp -ar -t $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/shaders $(@D)/*
	rm $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/shaders/Makefile
	rm $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/shaders/configure
endef

$(eval $(generic-package))
