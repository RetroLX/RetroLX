################################################################################
#
# SLANG SHADERS
#
################################################################################
# Version.: Commits on Jan 16, 2022
SLANG_SHADERS_VERSION = 27c5c481550cda6136c51062e00bfe478e718c99
SLANG_SHADERS_SITE = $(call github,libretro,slang-shaders,$(SLANG_SHADERS_VERSION))
SLANG_SHADERS_LICENSE = GPL

define SLANG_SHADERS_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile
endef

define SLANG_SHADERS_INSTALL_TARGET_CMDS
        # Create directories
        mkdir -p $(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)

	# Copy files
	$(MAKE) CXX="$(TARGET_CXX)" -C $(@D) INSTALLDIR=$(RETROARCH_PKG_DIR)$(RETROARCH_PKG_INSTALL_DIR)/usr/share/shaders install
endef

$(eval $(generic-package))
