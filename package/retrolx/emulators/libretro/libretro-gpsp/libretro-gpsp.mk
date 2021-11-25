################################################################################
#
# GPSP
#
################################################################################
# Commits. Version Nov 14, 2021
LIBRETRO_GPSP_VERSION = a2aa78733d8daf1d550c9dc76c6ff94e8670b31c
LIBRETRO_GPSP_SITE = $(call github,libretro,gpsp,$(LIBRETRO_GPSP_VERSION))
LIBRETRO_GPSP_LICENSE = GPLv2

LIBRETRO_GPSP_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_GPSP_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-gpsp

LIBRETRO_GPSP_PLATFORM = unix

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI1),y)
LIBRETRO_GPSP_PLATFORM = rpi1
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI2),y)
LIBRETRO_GPSP_PLATFORM = rpi2
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_AW32),y)
LIBRETRO_GPSP_PLATFORM = classic_armv7_a7
endif

define LIBRETRO_GPSP_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) platform=$(LIBRETRO_GPSP_PLATFORM)
endef

define LIBRETRO_GPSP_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_GPSP_PKG_DIR)$(LIBRETRO_GPSP_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/gpsp_libretro.so \
	$(LIBRETRO_GPSP_PKG_DIR)$(LIBRETRO_GPSP_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_GPSP_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-gpsp/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_GPSP_POST_INSTALL_TARGET_HOOKS = LIBRETRO_GPSP_MAKEPKG

$(eval $(generic-package))
