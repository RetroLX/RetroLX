################################################################################
#
# FCEUMM
#
################################################################################
# Version.: Commits on Jul 28, 2022
LIBRETRO_FCEUMM_VERSION = c9ca9204b5f4d02f3f67e14d077714e41632520a
LIBRETRO_FCEUMM_SITE = $(call github,libretro,libretro-fceumm,$(LIBRETRO_FCEUMM_VERSION))
LIBRETRO_FCEUMM_LICENSE = GPLv2

LIBRETRO_FCEUMM_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_FCEUMM_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-fceumm

LIBRETRO_FCEUMM_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
LIBRETRO_FCEUMM_PLATFORM = rpi3_64

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
LIBRETRO_FCEUMM_PLATFORM = rpi4

else ifeq ($(BR2_aarch64),y)
LIBRETRO_FCEUMM_PLATFORM = unix
endif

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
	LIBRETRO_FCEUMM_PLATFORM = armv
endif

define LIBRETRO_FCEUMM_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) -f Makefile.libretro platform="$(LIBRETRO_FCEUMM_PLATFORM)"
endef

define LIBRETRO_FCEUMM_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_FCEUMM_PKG_DIR)$(LIBRETRO_FCEUMM_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/fceumm_libretro.so \
	$(LIBRETRO_FCEUMM_PKG_DIR)$(LIBRETRO_FCEUMM_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_FCEUMM_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-fceumm/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_FCEUMM_POST_INSTALL_TARGET_HOOKS = LIBRETRO_FCEUMM_MAKEPKG

$(eval $(generic-package))
