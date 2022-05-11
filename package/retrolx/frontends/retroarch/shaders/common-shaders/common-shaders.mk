################################################################################
#
# COMMON SHADERS
#
################################################################################
# Version.: Commits on Apr 16, 2022
COMMON_SHADERS_VERSION = 86cfa146a8dfddf6377ddb5dbcff552feae2e5bf
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
