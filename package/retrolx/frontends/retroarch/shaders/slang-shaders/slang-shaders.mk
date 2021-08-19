################################################################################
#
# SLANG SHADERS
#
################################################################################
# Version.: Commits on Aug 19, 2021
SLANG_SHADERS_VERSION = 8f190244fd159823914e5ceb4a97847a15beb647
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
