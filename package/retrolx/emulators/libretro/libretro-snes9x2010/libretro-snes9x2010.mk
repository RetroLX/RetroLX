################################################################################
#
# SNES9X2010
#
################################################################################
# Version.: Commits on Aug 9, 2021
LIBRETRO_SNES9X2010_VERSION = 91826e15065e00f43e2d7bbe54e7795e4cfbb556
LIBRETRO_SNES9X2010_SITE = $(call github,libretro,snes9x2010,$(LIBRETRO_SNES9X2010_VERSION))
LIBRETRO_SNES9X2010_LICENSE = Non-commercial

LIBRETRO_SNES9X2010_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_SNES9X2010_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-snes9x2010

LIBRETRO_SNES9X2010_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S922X),y)
LIBRETRO_SNES9X2010_PLATFORM = CortexA73_G12B
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
LIBRETRO_SNES9X2010_PLATFORM = rpi4_64
else ifeq ($(BR2_aarch64),y)
LIBRETRO_SNES9X2010_PLATFORM = unix
endif

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
    ifeq ($(BR2_aarch64),y)
	    LIBRETRO_SNES9X2010_PLATFORM = rpi3_64
    else
        LIBRETRO_SNES9X2010_PLATFORM = rpi3
    endif
endif

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
        LIBRETRO_SNES9X2010_PLATFORM = armv cortexa9 neon hardfloat
endif

define LIBRETRO_SNES9X2010_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile.libretro platform="$(LIBRETRO_SNES9X2010_PLATFORM)"
endef

define LIBRETRO_SNES9X2010_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_SNES9X2010_PKG_DIR)$(LIBRETRO_SNES9X2010_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/snes9x2010_libretro.so \
	$(LIBRETRO_SNES9X2010_PKG_DIR)$(LIBRETRO_SNES9X2010_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_SNES9X2010_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-snes9x2010/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_SNES9X2010_POST_INSTALL_TARGET_HOOKS = LIBRETRO_SNES9X2010_MAKEPKG

$(eval $(generic-package))
