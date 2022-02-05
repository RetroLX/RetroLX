################################################################################
#
# NESTOPIA
#
################################################################################
# Version.: Commits on Jan 29, 2022
LIBRETRO_NESTOPIA_VERSION = def66a58f0c0b38cdf72909ff9d9480344a98032
LIBRETRO_NESTOPIA_SITE = $(call github,libretro,nestopia,$(LIBRETRO_NESTOPIA_VERSION))
LIBRETRO_NESTOPIA_LICENSE = GPLv2

LIBRETRO_NESTOPIA_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_NESTOPIA_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-nestopia

LIBRETRO_NESTOPIA_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
LIBRETRO_NESTOPIA_PLATFORM = armv

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
LIBRETRO_NESTOPIA_PLATFORM = rpi3_64

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
LIBRETRO_NESTOPIA_PLATFORM = rpi4_64

else ifeq ($(BR2_aarch64),y)
LIBRETRO_NESTOPIA_PLATFORM = unix
endif

define LIBRETRO_NESTOPIA_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/libretro/ platform="$(LIBRETRO_NESTOPIA_PLATFORM)"
endef

define LIBRETRO_NESTOPIA_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_NESTOPIA_PKG_DIR)$(LIBRETRO_NESTOPIA_PKG_INSTALL_DIR)/bios

	# Copy package files
	$(INSTALL) -D $(@D)/libretro/nestopia_libretro.so \
	$(LIBRETRO_NESTOPIA_PKG_DIR)$(LIBRETRO_NESTOPIA_PKG_INSTALL_DIR)
	$(INSTALL) -D $(@D)/NstDatabase.xml \
	$(LIBRETRO_NESTOPIA_PKG_DIR)$(LIBRETRO_NESTOPIA_PKG_INSTALL_DIR)/bios/NstDatabase.xml

	# Build Pacman package
	cd $(LIBRETRO_NESTOPIA_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-nestopia/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_NESTOPIA_POST_INSTALL_TARGET_HOOKS = LIBRETRO_NESTOPIA_MAKEPKG

$(eval $(generic-package))
