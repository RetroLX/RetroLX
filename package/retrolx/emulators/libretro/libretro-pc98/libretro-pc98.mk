################################################################################
#
# LIBRETRO PC98
#
################################################################################
# Version.: Commits on May 10, 2020
LIBRETRO_PC98_VERSION = rev.22
LIBRETRO_PC98_SITE = $(call github,AZO234,NP2kai,$(LIBRETRO_PC98_VERSION))
LIBRETRO_PC98_LICENSE = GPLv3

LIBRETRO_PC98_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_PC98_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-pc98

LIBRETRO_PC98_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S922X),y)
LIBRETRO_PC98_PLATFORM = CortexA73_G12B

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
LIBRETRO_PC98_PLATFORM = odroid

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_EXYNOS5422),y)
	LIBRETRO_PC98_PLATFORM = odroidxu

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3399),y)
LIBRETRO_PC98_PLATFORM = RK3399

else ifeq ($(BR2_aarch64),y)
LIBRETRO_PC98_PLATFORM = unix
endif

define LIBRETRO_PC98_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/sdl2/ -f Makefile.libretro platform="$(LIBRETRO_PC98_PLATFORM)"
endef

define LIBRETRO_PC98_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_PC98_PKG_DIR)$(LIBRETRO_PC98_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/sdl2/np2kai_libretro.so \
	$(LIBRETRO_PC98_PKG_DIR)$(LIBRETRO_PC98_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_PC98_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-pc98/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_PC98_POST_INSTALL_TARGET_HOOKS = LIBRETRO_PC98_MAKEPKG

$(eval $(generic-package))
