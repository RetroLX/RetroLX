################################################################################
#
# GLSL SHADERS
#
################################################################################
# Version.: Commits on Aug 25, 2022
GLSL_SHADERS_VERSION = 2aec58e7e75083b689d38e3c4eaf043589ffd36f
GLSL_SHADERS_SITE = $(call github,libretro,glsl-shaders,$(GLSL_SHADERS_VERSION))
GLSL_SHADERS_LICENSE = GPL
GLSL_SHADERS_DEPENDENCIES += common-shaders

define GLSL_SHADERS_BUILD_CMDS
endef

define GLSL_SHADERS_INSTALL_TARGET_CMDS
        # Simple copy, remove Makefile / configure
        mkdir -p $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/shaders
        cp -ar -t $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/shaders $(@D)/*
        rm $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/shaders/Makefile
        rm $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/shaders/configure

	# Enable crt-pi curvature
	sed -e "s:^//#define CURVATURE:#define CURVATURE:" $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/shaders/crt/shaders/crt-pi.glsl > $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/shaders/crt/shaders/crt-pi-curvature.glsl
	sed -e 's:^shader0 = "shaders/crt-pi.glsl":shader0 = "shaders/crt-pi-curvature.glsl":' $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/shaders/crt/crt-pi.glslp > $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/shaders/crt/crt-pi-curvature.glslp
endef

$(eval $(generic-package))
