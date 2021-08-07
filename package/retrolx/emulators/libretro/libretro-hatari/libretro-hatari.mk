################################################################################
#
# HATARI
#
################################################################################
# Version.: Commits on Mar 17, 2021
LIBRETRO_HATARI_VERSION = cea06eebf695b078fadc0e78bb0f2b2baaca799f
LIBRETRO_HATARI_SITE = $(call github,libretro,hatari,$(LIBRETRO_HATARI_VERSION))
LIBRETRO_HATARI_DEPENDENCIES = libcapsimage retroarch
LIBRETRO_HATARI_LICENSE = GPLv2

LIBRETRO_HATARI_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_HATARI_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-hatari

LIBRETRO_HATARI_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S812),y)
LIBRETRO_HATARI_PLATFORM = armv

else ifeq ($(BR2_aarch64),y)
LIBRETRO_HATARI_PLATFORM = unix

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RPI3),y)
LIBRETRO_HATARI_PLATFORM = armv
endif

define LIBRETRO_HATARI_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile.libretro platform="$(LIBRETRO_HATARI_PLATFORM)"
endef

define LIBRETRO_HATARI_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_HATARI_PKG_DIR)$(LIBRETRO_HATARI_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/hatari_libretro.so \
	$(LIBRETRO_HATARI_PKG_DIR)$(LIBRETRO_HATARI_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_HATARI_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-hatari/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_HATARI_POST_INSTALL_TARGET_HOOKS = LIBRETRO_HATARI_MAKEPKG

$(eval $(generic-package))
