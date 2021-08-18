################################################################################
#
# VECX
#
################################################################################
# Version.: Commits on Aug 15, 2021
LIBRETRO_VECX_VERSION = 68164b2cb604ead327944fa3d0653dda035da37b
LIBRETRO_VECX_SITE = $(call github,libretro,libretro-vecx,$(LIBRETRO_VECX_VERSION))
LIBRETRO_VECX_LICENSE = GPLv2|LGPLv2.1

LIBRETRO_VECX_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_VECX_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-vecx


ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
LIBRETRO_VECX_DEPENDENCIES += libgl
else
ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
LIBRETRO_VECX_DEPENDENCIES += libgles
LIBRETRO_VECX_MAKE_OPTS += GLES=1
LIBRETRO_VECX_MAKE_OPTS += GL_LIB=-lGLESv2
else
LIBRETRO_VECX_MAKE_OPTS += HAS_GPU=0
endif
endif

LIBRETRO_VECX_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_aarch64),y)
LIBRETRO_VECX_PLATFORM = unix

else ifeq ($(BR2_PACKAGE_RETROLX_RPI_VCORE),y)
LIBRETRO_VECX_PLATFORM = rpi

else ifeq ($(BR2_PACKAGE_RETROLX_RPI_MESA3D),y)
LIBRETRO_VECX_PLATFORM = rpi-mesa

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
LIBRETRO_VECX_PLATFORM = armv

else ifeq ($(BR2_PACKAGE_HAS_LIBMALI),y)
LIBRETRO_VECX_PLATFORM = unix
endif

LIBRETRO_VECX_MAKE_OPTS += platform="$(LIBRETRO_VECX_PLATFORM)"

define LIBRETRO_VECX_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile.libretro $(LIBRETRO_VECX_MAKE_OPTS)
endef

define LIBRETRO_VECX_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_VECX_PKG_DIR)$(LIBRETRO_VECX_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/vecx_libretro.so \
	$(LIBRETRO_VECX_PKG_DIR)$(LIBRETRO_VECX_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_VECX_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-vecx/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_VECX_POST_INSTALL_TARGET_HOOKS = LIBRETRO_VECX_MAKEPKG

$(eval $(generic-package))
