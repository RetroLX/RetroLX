################################################################################
#
# BLASTEM
#
################################################################################
# Version.: Commits on Mar 09, 2021
LIBRETRO_BLASTEM_VERSION = a61b47d5489e
LIBRETRO_BLASTEM_SOURCE = $(LIBRETRO_BLASTEM_VERSION).tar.gz
LIBRETRO_BLASTEM_SITE = https://www.retrodev.com/repos/blastem/archive
LIBRETRO_BLASTEM_LICENSE = Non-commercial

LIBRETRO_BLASTEM_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_BLASTEM_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-blastem

LIBRETRO_BLASTEM_EXTRAOPTS=""

ifeq ($(BR2_x86_64),y)
LIBRETRO_BLASTEM_EXTRAOPTS=CPU=x86_64
else  ifeq ($(BR2_x86_i686),y)
LIBRETRO_BLASTEM_EXTRAOPTS=CPU=i686
endif

define LIBRETRO_BLASTEM_BUILD_CMDS
    $(SED) "s+CPU:=i686+CPU?=i686+g" $(@D)/Makefile
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) libblastem.so $(LIBRETRO_BLASTEM_EXTRAOPTS)
endef

define LIBRETRO_GENESISPLUSGX_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_BLASTEM_PKG_DIR)$(LIBRETRO_BLASTEM_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/libblastem.so \
	$(LIBRETRO_BLASTEM_PKG_DIR)$(LIBRETRO_BLASTEM_PKG_INSTALL_DIR)/blastem_libretro.so

	# Build Pacman package
	cd $(LIBRETRO_BLASTEM_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-blastem/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_BLASTEM_POST_INSTALL_TARGET_HOOKS = LIBRETRO_BLASTEM_MAKEPKG

$(eval $(generic-package))

