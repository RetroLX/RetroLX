################################################################################
#
# PRBOOM
#
################################################################################
# Version.: Commits on Nov 9, 2021
LIBRETRO_PRBOOM_VERSION = 0f5927db4fb7e61f32bc9eccc5f809e54f71a371
LIBRETRO_PRBOOM_SITE = $(call github,libretro,libretro-prboom,$(LIBRETRO_PRBOOM_VERSION))
LIBRETRO_PRBOOM_LICENSE = GPLv2

LIBRETRO_PRBOOM_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_PRBOOM_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-prboom

LIBRETRO_PRBOOM_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
LIBRETRO_PRBOOM_PLATFORM = armv neon

else ifeq ($(BR2_aarch64),y)
LIBRETRO_PRBOOM_PLATFORM = unix

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
LIBRETRO_PRBOOM_PLATFORM = armv neon
endif

define LIBRETRO_PRBOOM_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_PRBOOM_PLATFORM)"
endef

define LIBRETRO_PRBOOM_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_PRBOOM_PKG_DIR)$(LIBRETRO_PRBOOM_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/prboom_libretro.so \
	$(LIBRETRO_PRBOOM_PKG_DIR)$(LIBRETRO_PRBOOM_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_PRBOOM_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-prboom/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_PRBOOM_POST_INSTALL_TARGET_HOOKS = LIBRETRO_PRBOOM_MAKEPKG

$(eval $(generic-package))
