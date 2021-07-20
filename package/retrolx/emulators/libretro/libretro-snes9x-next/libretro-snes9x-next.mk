################################################################################
#
# SNES9X_NEXT
#
################################################################################
# Version.: Commits on Apr 23, 2021
LIBRETRO_SNES9X_NEXT_VERSION = 1649a31d1ea0cc10a181ea4fec2698950c4ee780
LIBRETRO_SNES9X_NEXT_SITE = $(call github,libretro,snes9x2010,$(LIBRETRO_SNES9X_NEXT_VERSION))
LIBRETRO_SNES9X_NEXT_LICENSE = Non-commercial

LIBRETRO_SNES9X_NEXT_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_SNES9X_NEXT_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-snes9x-next

LIBRETRO_SNES9X_NEXT_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S922X),y)
LIBRETRO_SNES9X_NEXT_PLATFORM = CortexA73_G12B
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RPI4),y)
LIBRETRO_SNES9X_NEXT_PLATFORM = rpi4_64
else ifeq ($(BR2_aarch64),y)
LIBRETRO_SNES9X_NEXT_PLATFORM = unix
endif

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RPI3),y)
    ifeq ($(BR2_aarch64),y)
	    LIBRETRO_SNES9X_NEXT_PLATFORM = rpi3_64
    else
        LIBRETRO_SNES9X_NEXT_PLATFORM = rpi3
    endif
endif

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S812),y)
        LIBRETRO_SNES9X_NEXT_PLATFORM = armv cortexa9 neon hardfloat
endif

define LIBRETRO_SNES9X_NEXT_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile.libretro platform="$(LIBRETRO_SNES9X_NEXT_PLATFORM)"
endef

define LIBRETRO_SNES9X_NEXT_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_SNES9X_NEXT_PKG_DIR)$(LIBRETRO_SNES9X_NEXT_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/snes9x2010_libretro.so \
	$(LIBRETRO_SNES9X_NEXT_PKG_DIR)$(LIBRETRO_SNES9X_NEXT_PKG_INSTALL_DIR)/snes9x_next_libretro.so

	# Build Pacman package
	cd $(LIBRETRO_SNES9X_NEXT_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-snes9x-next/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_SNES9X_NEXT_POST_INSTALL_TARGET_HOOKS = LIBRETRO_SNES9X_NEXT_MAKEPKG

$(eval $(generic-package))
