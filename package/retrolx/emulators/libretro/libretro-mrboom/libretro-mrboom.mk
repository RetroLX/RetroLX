################################################################################
#
# MRBOOM
#
################################################################################
# Version.: Commits on Mar 14, 2021
LIBRETRO_MRBOOM_VERSION = e4bec7e0962e4ba1fd8be5bfdcc1683647ef0349
LIBRETRO_MRBOOM_SITE = https://github.com/Javanaise/mrboom-libretro.git
LIBRETRO_MRBOOM_SITE_METHOD=git
LIBRETRO_MRBOOM_GIT_SUBMODULES=YES
LIBRETRO_MRBOOM_LICENSE=GPLv2

LIBRETRO_MRBOOM_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_MRBOOM_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-mrboom

ifeq ($(BR2_ARM_FPU_NEON_VFPV4)$(BR2_ARM_FPU_NEON)$(BR2_ARM_FPU_NEON_FP_ARMV8),y)
LIBRETRO_MRBOOM_EXTRA_ARGS = HAVE_NEON=1
endif

define LIBRETRO_MRBOOM_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform=unix $(LIBRETRO_MRBOOM_EXTRA_ARGS)
endef

define LIBRETRO_MRBOOM_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_MRBOOM_PKG_DIR)$(LIBRETRO_MRBOOM_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/mrboom_libretro.so \
	$(LIBRETRO_MRBOOM_PKG_DIR)$(LIBRETRO_MRBOOM_PKG_INSTALL_DIR)/mrboom_libretro.so

	# Build Pacman package
	cd $(LIBRETRO_MRBOOM_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-mrboom/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_MRBOOM_POST_INSTALL_TARGET_HOOKS = LIBRETRO_MRBOOM_MAKEPKG

$(eval $(generic-package))
