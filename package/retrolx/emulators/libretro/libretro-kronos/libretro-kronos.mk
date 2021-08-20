################################################################################
#
# LIBRETRO-KRONOS
#
################################################################################
# Version.: Commits on Aug 20, 2021
LIBRETRO_KRONOS_VERSION = ddecc6b1d7e5f12b3d125e39b91e7cd6ec49d60d
LIBRETRO_KRONOS_SITE = $(call github,FCare,kronos,$(LIBRETRO_KRONOS_VERSION))
LIBRETRO_KRONOS_LICENSE = BSD-3-Clause

LIBRETRO_KRONOS_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_KRONOS_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-kronos

LIBRETRO_KRONOS_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_EXYNOS5422),y)
        LIBRETRO_KRONOS_PLATFORM = odroid
        LIBRETRO_KRONOS_EXTRA_ARGS += BOARD=ODROID-XU4 FORCE_GLES=1

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S922X),y)
LIBRETRO_KRONOS_PLATFORM = odroid-n2
LIBRETRO_KRONOS_EXTRA_ARGS += FORCE_GLES=1

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RK3399),y)
LIBRETRO_KRONOS_PLATFORM = rockpro64
LIBRETRO_KRONOS_EXTRA_ARGS += FORCE_GLES=1

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S905GEN3),y)
LIBRETRO_KRONOS_PLATFORM = odroid-c4
LIBRETRO_KRONOS_EXTRA_ARGS += FORCE_GLES=1
endif

define LIBRETRO_KRONOS_BUILD_CMDS
	$(MAKE) -C $(@D)/yabause/src/libretro -f Makefile generate-files && \
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/yabause/src/libretro -f Makefile platform="$(LIBRETRO_KRONOS_PLATFORM)" $(LIBRETRO_KRONOS_EXTRA_ARGS)
endef

define LIBRETRO_KRONOS_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_KRONOS_PKG_DIR)$(LIBRETRO_KRONOS_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/yabause/src/libretro/kronos_libretro.so \
	$(LIBRETRO_KRONOS_PKG_DIR)$(LIBRETRO_KRONOS_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_KRONOS_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-kronos/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_KRONOS_POST_INSTALL_TARGET_HOOKS = LIBRETRO_KRONOS_MAKEPKG

$(eval $(generic-package))
