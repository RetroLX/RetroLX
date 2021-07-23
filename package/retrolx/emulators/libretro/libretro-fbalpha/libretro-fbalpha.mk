################################################################################
#
# FBALPHA
#
################################################################################
# Version.: Commits on Apr 30, 2021
LIBRETRO_FBALPHA_VERSION = 0a25932ac981108a5eb5ef401056ac78ea57e3ce
LIBRETRO_FBALPHA_SITE = $(call github,libretro,fbalpha,$(LIBRETRO_FBALPHA_VERSION))
LIBRETRO_FBALPHA_LICENSE = Non-commercial

LIBRETRO_FBALPHA_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_FBALPHA_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-fbalpha

define LIBRETRO_FBALPHA_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f makefile.libretro platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_FBALPHA_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_FBALPHA_PKG_DIR)$(LIBRETRO_FBALPHA_PKG_INSTALL_DIR)/bios/samples

	# Copy package files
	$(INSTALL) -D $(@D)/src/burner/libretro/fbalpha_libretro.so $(LIBRETRO_FBALPHA_PKG_DIR)$(LIBRETRO_FBALPHA_PKG_INSTALL_DIR)
	$(INSTALL) -D $(@D)/metadata/* $(LIBRETRO_FBALPHA_PKG_DIR)$(LIBRETRO_FBALPHA_PKG_INSTALL_DIR)/bios/
	$(INSTALL) -D $(@D)/dats/* $(LIBRETRO_FBALPHA_PKG_DIR)$(LIBRETRO_FBALPHA_PKG_INSTALL_DIR)/bios/

	# Build Pacman package
	cd $(LIBRETRO_FBALPHA_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-fbalpha/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_FBALPHA_POST_INSTALL_TARGET_HOOKS = LIBRETRO_FBALPHA_MAKEPKG

$(eval $(generic-package))
