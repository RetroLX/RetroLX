################################################################################
#
# ECWOLF
#
################################################################################
# Version.: Commits on Feb 3, 2022
LIBRETRO_ECWOLF_VERSION = b1bbd64ed9d495c6d532db318d05aff658d2c731
LIBRETRO_ECWOLF_SITE = https://github.com/libretro/ecwolf
LIBRETRO_ECWOLF_SITE_METHOD = git
LIBRETRO_ECWOLF_LICENSE = Non-commercial
LIBRETRO_ECWOLF_GIT_SUBMODULES = YES

LIBRETRO_ECWOLF_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_ECWOLF_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-ecwolf

LIBRETRO_ECWOLF_PLATFORM = $(LIBRETRO_PLATFORM)

define LIBRETRO_ECWOLF_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" GIT_VERSION="" -C $(@D)/src/libretro/ -f Makefile platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_ECWOLF_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_ECWOLF_PKG_DIR)$(LIBRETRO_ECWOLF_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/src/libretro/ecwolf_libretro.so \
	$(LIBRETRO_ECWOLF_PKG_DIR)$(LIBRETRO_ECWOLF_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_ECWOLF_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-ecwolf/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_ECWOLF_POST_INSTALL_TARGET_HOOKS = LIBRETRO_ECWOLF_MAKEPKG

$(eval $(generic-package))
