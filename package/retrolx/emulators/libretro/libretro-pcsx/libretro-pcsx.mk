################################################################################
#
# PCSXREARMED
#
################################################################################
# Version.: Commits on Dec 21, 2021
LIBRETRO_PCSX_VERSION = 12fc12797064599dfca2d44043d5c02a949711ef
LIBRETRO_PCSX_SITE = $(call github,libretro,pcsx_rearmed,$(LIBRETRO_PCSX_VERSION))
LIBRETRO_PCSX_LICENSE = GPLv2

LIBRETRO_PCSX_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_PCSX_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-pcsx

LIBRETRO_PCSX_PLATFORM = $(LIBRETRO_PLATFORM)
LIBRETRO_PCSX_DYNAREC = 

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S922X),y)
LIBRETRO_PCSX_PLATFORM = CortexA73_G12B

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI4),y)
LIBRETRO_PCSX_PLATFORM = rpi4_64

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_ARM64_A53_GLES2),y)
LIBRETRO_PCSX_PLATFORM = h5

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_RPI3),y)
LIBRETRO_PCSX_PLATFORM = rpi3_64

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_S812),y)
LIBRETRO_PCSX_PLATFORM = armv cortexa9 neon hardfloat

else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_AW32),y)
LIBRETRO_PCSX_PLATFORM = rpi2

else ifeq ($(BR2_arm)$(BR2_aarch64),y)
LIBRETRO_PCSX_PLATFORM = unix
LIBRETRO_PCSX_DYNAREC = ari64
endif

define LIBRETRO_PCSX_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) -f Makefile.libretro platform="$(LIBRETRO_PCSX_PLATFORM)" DYNAREC="$(LIBRETRO_PCSX_DYNAREC)"
endef

define LIBRETRO_PCSX_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_PCSX_PKG_DIR)$(LIBRETRO_PCSX_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/pcsx_rearmed_libretro.so \
	$(LIBRETRO_PCSX_PKG_DIR)$(LIBRETRO_PCSX_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_PCSX_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-pcsx/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_PCSX_POST_INSTALL_TARGET_HOOKS = LIBRETRO_PCSX_MAKEPKG

$(eval $(generic-package))
