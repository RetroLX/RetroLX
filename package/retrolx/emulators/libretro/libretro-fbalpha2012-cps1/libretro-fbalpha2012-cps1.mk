################################################################################
#
# FBALPHA2012_CPS1
#
################################################################################
# Version.: Commits on Oct 8, 2021
LIBRETRO_FBALPHA2012_CPS1_VERSION = 2799309b7c74cdb11be24509368b4d6ce1b148b1
LIBRETRO_FBALPHA2012_CPS1_SITE = $(call github,libretro,fbalpha2012_cps1,$(LIBRETRO_FBALPHA2012_CPS1_VERSION))
LIBRETRO_FBALPHA2012_CPS1_LICENSE = Non-commercial

LIBRETRO_FBALPHA2012_CPS1_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_FBALPHA2012_CPS1_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-fbalpha2012-cps1

define LIBRETRO_FBALPHA2012_CPS1_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f makefile.libretro
endef

define LIBRETRO_FBALPHA2012_CPS1_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_FBALPHA2012_CPS1_PKG_DIR)$(LIBRETRO_FBALPHA2012_CPS1_PKG_INSTALL_DIR)/bios/samples

	# Copy package files
	$(INSTALL) -D $(@D)/fbalpha2012_cps1_libretro.so $(LIBRETRO_FBALPHA2012_CPS1_PKG_DIR)$(LIBRETRO_FBALPHA2012_CPS1_PKG_INSTALL_DIR)
	#$(INSTALL) -D $(@D)/metadata/* $(LIBRETRO_FBALPHA2012_CPS1_PKG_DIR)$(LIBRETRO_FBALPHA2012_CPS1_PKG_INSTALL_DIR)/bios/
	#$(INSTALL) -D $(@D)/dats/* $(LIBRETRO_FBALPHA2012_CPS1_PKG_DIR)$(LIBRETRO_FBALPHA2012_CPS1_PKG_INSTALL_DIR)/bios/

	# Build Pacman package
	cd $(LIBRETRO_FBALPHA2012_CPS1_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-fbalpha2012-cps1/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_FBALPHA2012_CPS1_POST_INSTALL_TARGET_HOOKS = LIBRETRO_FBALPHA2012_CPS1_MAKEPKG

$(eval $(generic-package))
