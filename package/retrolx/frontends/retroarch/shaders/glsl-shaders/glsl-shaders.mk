################################################################################
#
# GLSL SHADERS
#
################################################################################
# Version.: Commits on Jul 19, 2021
GLSL_SHADERS_VERSION = 3c4dba36ec32c11c677376ead912f1bbb1ec7613
GLSL_SHADERS_SITE = $(call github,libretro,glsl-shaders,$(GLSL_SHADERS_VERSION))
GLSL_SHADERS_LICENSE = GPL

define GLSL_SHADERS_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile
endef

define GLSL_SHADERS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/retrolx/shaders
	$(MAKE) CXX="$(TARGET_CXX)" -C $(@D) INSTALLDIR=$(TARGET_DIR)/usr/share/retrolx/shaders install
	sed -e "s:^//#define CURVATURE:#define CURVATURE:" $(TARGET_DIR)/usr/share/retrolx/shaders/crt/shaders/crt-pi.glsl > $(TARGET_DIR)/usr/share/retrolx/shaders/crt/shaders/crt-pi-curvature.glsl
	sed -e 's:^shader0 = "shaders/crt-pi.glsl":shader0 = "shaders/crt-pi-curvature.glsl":' $(TARGET_DIR)/usr/share/retrolx/shaders/crt/crt-pi.glslp > $(TARGET_DIR)/usr/share/retrolx/shaders/crt/crt-pi-curvature.glslp
endef

$(eval $(generic-package))
