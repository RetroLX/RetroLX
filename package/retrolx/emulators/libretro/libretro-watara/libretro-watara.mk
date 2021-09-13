################################################################################
#
# WATARA
#
################################################################################
# Version.: Commits on Sep 12, 2021
LIBRETRO_WATARA_VERSION = dacb12c8eb1a9adc96972969634d219eace35ff3
LIBRETRO_WATARA_SITE = $(call github,libretro,potator,$(LIBRETRO_WATARA_VERSION))
LIBRETRO_WATARA_LICENSE = GPLv2

LIBRETRO_WATARA_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_WATARA_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-watara

LIBRETRO_WATARA_PLATFORM = $(LIBRETRO_PLATFORM)
LIBRETRO_WATARA_EXTRA_ARGS =

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI1),y)
LIBRETRO_WATARA_PLATFORM = rpi1

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI2),y)
LIBRETRO_WATARA_PLATFORM = rpi2

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
    ifeq ($(BR2_aarch64),y)
        LIBRETRO_WATARA_PLATFORM = rpi3_64
    else
        LIBRETRO_WATARA_PLATFORM = rpi3
    endif

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
LIBRETRO_WATARA_PLATFORM = rpi4

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
LIBRETRO_WATARA_PLATFORM = armv cortexa9 neon hardfloat

else ifeq ($(BR2_aarch64),y)
LIBRETRO_WATARA_PLATFORM = aarch64
LIBRETRO_WATARA_EXTRA_ARGS += ARCH=arm64

else ifeq ($(BR2_x86_64),y)
LIBRETRO_WATARA_EXTRA_ARGS += ARCH=x86_64
endif

define LIBRETRO_WATARA_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/platform/libretro -f Makefile platform="$(LIBRETRO_WATARA_PLATFORM)" $(LIBRETRO_WATARA_EXTRA_ARGS)
endef

define LIBRETRO_WATARA_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_WATARA_PKG_DIR)$(LIBRETRO_WATARA_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/platform/libretro/potator_libretro.so \
	$(LIBRETRO_WATARA_PKG_DIR)$(LIBRETRO_WATARA_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_WATARA_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-watara/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_WATARA_POST_INSTALL_TARGET_HOOKS = LIBRETRO_WATARA_MAKEPKG

$(eval $(generic-package))
