################################################################################
#
# FBALPHA2012_NEOGEO
#
################################################################################
# Version.: Commits on Avr 30, 2021
LIBRETRO_FBALPHA2012_NEOGEO_VERSION = 06261f376504ca988aea6093a0999e8b081ff715
LIBRETRO_FBALPHA2012_NEOGEO_SITE = $(call github,libretro,fbalpha2012_neogeo,$(LIBRETRO_FBALPHA2012_NEOGEO_VERSION))
LIBRETRO_FBALPHA2012_NEOGEO_LICENSE = Non-commercial

LIBRETRO_FBALPHA2012_NEOGEO_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_FBALPHA2012_NEOGEO_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-fbalpha2012-neogeo

define LIBRETRO_FBALPHA2012_NEOGEO_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f makefile.libretro platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_FBALPHA2012_NEOGEO_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_FBALPHA2012_NEOGEO_PKG_DIR)$(LIBRETRO_FBALPHA2012_NEOGEO_PKG_INSTALL_DIR)/bios/samples

	# Copy package files
	$(INSTALL) -D $(@D)/fbalpha2012_libretro.so $(LIBRETRO_FBALPHA2012_NEOGEO_PKG_DIR)$(LIBRETRO_FBALPHA2012_NEOGEO_PKG_INSTALL_DIR)
	#$(INSTALL) -D $(@D)/metadata/* $(LIBRETRO_FBALPHA2012_PKG_DIR)$(LIBRETRO_FBALPHA2012_PKG_INSTALL_DIR)/bios/
	#$(INSTALL) -D $(@D)/dats/* $(LIBRETRO_FBALPHA2012_PKG_DIR)$(LIBRETRO_FBALPHA2012_PKG_INSTALL_DIR)/bios/

	# Build Pacman package
	cd $(LIBRETRO_FBALPHA2012_NEOGEO_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-fbalpha2012-neogeo/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_FBALPHA2012_NEOGEO_POST_INSTALL_TARGET_HOOKS = LIBRETRO_FBALPHA2012_NEOGEO_MAKEPKG

$(eval $(generic-package))
