################################################################################
#
# SLANG SHADERS
#
################################################################################
# Version.: Commits on Sep 8, 2021
SLANG_SHADERS_VERSION = 38de4161cd131e84906359cc1f0013b06dff06be
SLANG_SHADERS_SITE = $(call github,libretro,slang-shaders,$(SLANG_SHADERS_VERSION))
SLANG_SHADERS_LICENSE = GPL

define SLANG_SHADERS_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile
endef

define SLANG_SHADERS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/retrolx/shaders
	$(MAKE) CXX="$(TARGET_CXX)" -C $(@D) INSTALLDIR=$(TARGET_DIR)/usr/share/retrolx/shaders install
endef

$(eval $(generic-package))
