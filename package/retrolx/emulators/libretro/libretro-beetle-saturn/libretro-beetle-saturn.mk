################################################################################
#
# BEETLE-SATURN
#
################################################################################
# Version.: Commits on Oct 2, 2021
LIBRETRO_BEETLE_SATURN_VERSION = f90e099abc789b09abdd927f60befd77b2c87f8e
LIBRETRO_BEETLE_SATURN_SITE = $(call github,libretro,beetle-saturn-libretro,$(LIBRETRO_BEETLE_SATURN_VERSION))
LIBRETRO_BEETLE_SATURN_LICENSE = GPLv2

LIBRETRO_BEETLE_SATURN_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_BEETLE_SATURN_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-beetle-saturn

define LIBRETRO_BEETLE_SATURN_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) -f Makefile HAVE_OPENGL=1 platform="$(LIBRETRO_PLATFORM)"
endef

define LIBRETRO_BEETLE_SATURN_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_BEETLE_SATURN_PKG_DIR)$(LIBRETRO_BEETLE_SATURN_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/mednafen_saturn_hw_libretro.so \
	$(LIBRETRO_BEETLE_SATURN_PKG_DIR)$(LIBRETRO_BEETLE_SATURN_PKG_INSTALL_DIR)/beetle-saturn_libretro.so

	# Build Pacman package
	cd $(LIBRETRO_BEETLE_SATURN_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-beetle-saturn/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_BEETLE_SATURN_POST_INSTALL_TARGET_HOOKS = LIBRETRO_BEETLE_SATURN_MAKEPKG

$(eval $(generic-package))
