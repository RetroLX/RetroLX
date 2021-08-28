################################################################################
#
# FBALPHA
#
################################################################################
# Version.: Commits on May 29, 2021
LIBRETRO_FBALPHA2012_CPS3_VERSION = 5ae6afeda0af01925e42e1f8dc5aca2a825afc51
LIBRETRO_FBALPHA2012_CPS3_SITE = $(call github,libretro,fbalpha2012_cps3,$(LIBRETRO_FBALPHA2012_CPS3_VERSION))
LIBRETRO_FBALPHA2012_CPS3_LICENSE = Non-commercial

LIBRETRO_FBALPHA2012_CPS3_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_FBALPHA2012_CPS3_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-fbalpha2012-cps3

define LIBRETRO_FBALPHA2012_CPS3_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/svn-current/trunk/ -f makefile.libretro
endef

define LIBRETRO_FBALPHA2012_CPS3_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_FBALPHA2012_CPS3_PKG_DIR)$(LIBRETRO_FBALPHA2012_CPS3_PKG_INSTALL_DIR)/bios/samples

	# Copy package files
	$(INSTALL) -D $(@D)/svn-current/trunk/fbalpha2012_cps3_libretro.so $(LIBRETRO_FBALPHA2012_CPS3_PKG_DIR)$(LIBRETRO_FBALPHA2012_CPS3_PKG_INSTALL_DIR)
	#$(INSTALL) -D $(@D)/metadata/* $(LIBRETRO_FBALPHA2012_CPS3_PKG_DIR)$(LIBRETRO_FBALPHA2012_CPS3_PKG_INSTALL_DIR)/bios/
	#$(INSTALL) -D $(@D)/dats/* $(LIBRETRO_FBALPHA2012_CPS3_PKG_DIR)$(LIBRETRO_FBALPHA2012_CPS3_PKG_INSTALL_DIR)/bios/

	# Build Pacman package
	cd $(LIBRETRO_FBALPHA2012_CPS3_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-fbalpha2012-cps3/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_FBALPHA2012_CPS3_POST_INSTALL_TARGET_HOOKS = LIBRETRO_FBALPHA2012_CPS3_MAKEPKG

$(eval $(generic-package))
