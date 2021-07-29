################################################################################
#
# libretro-picodrive
#
################################################################################
# Version.: Commits on Apr 2, 2021
LIBRETRO_PICODRIVE_VERSION = v1.98
LIBRETRO_PICODRIVE_SITE = https://github.com/irixxxx/picodrive.git
LIBRETRO_PICODRIVE_SITE_METHOD=git
LIBRETRO_PICODRIVE_GIT_SUBMODULES=YES
LIBRETRO_PICODRIVE_DEPENDENCIES = libpng
LIBRETRO_PICODRIVE_LICENSE = MAME

LIBRETRO_PICODRIVE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_PICODRIVE_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-picodrive

LIBRETRO_PICODRIVE_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_arm),y)
LIBRETRO_PICODRIVE_PLATFORM += armv neon hardfloat

else ifeq ($(BR2_aarch64),y)
LIBRETRO_PICODRIVE_PLATFORM = aarch64

else ifeq ($(BR2_PACKAGE_BATOCERA_IS_X86_ARCH),y)
LIBRETRO_PICODRIVE_PLATFORM = unix
endif

define LIBRETRO_PICODRIVE_BUILD_CMDS
	$(MAKE) -C $(@D)/cpu/cyclone CONFIG_FILE=$(@D)/cpu/cyclone_config.h
	# force -j 1 to avoid parallel issues in the makefile
	cd $(@D) && $(TARGET_CONFIGURE_OPTS) $(MAKE) -j 1 CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C  $(@D) -f Makefile.libretro platform="$(LIBRETRO_PICODRIVE_PLATFORM)"
endef

define LIBRETRO_PICODRIVE_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_PICODRIVE_PKG_DIR)$(LIBRETRO_PICODRIVE_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/picodrive_libretro.so \
	$(LIBRETRO_PICODRIVE_PKG_DIR)$(LIBRETRO_PICODRIVE_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_PICODRIVE_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-picodrive/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_PICODRIVE_POST_INSTALL_TARGET_HOOKS = LIBRETRO_PICODRIVE_MAKEPKG

$(eval $(generic-package))
