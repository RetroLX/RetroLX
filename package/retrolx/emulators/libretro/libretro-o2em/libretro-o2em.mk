################################################################################
#
# O2EM
#
################################################################################
# Version.: Commits on Aug 5, 2021
LIBRETRO_O2EM_VERSION = e09a952964dea7ef164a634288e1134dba6e4a56
LIBRETRO_O2EM_SITE = $(call github,libretro,libretro-o2em,$(LIBRETRO_O2EM_VERSION))
LIBRETRO_O2EM_LICENSE = Artistic License

LIBRETRO_O2EM_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_O2EM_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/lr-o2em

LIBRETRO_O2EM_PLATFORM = $(LIBRETRO_PLATFORM)

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S812),y)
LIBRETRO_O2EM_PLATFORM = armv neon

else ifeq ($(BR2_aarch64),y)
LIBRETRO_O2EM_PLATFORM = unix

else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RPI3),y)
LIBRETRO_O2EM_PLATFORM = armv neon
endif

define LIBRETRO_O2EM_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(LIBRETRO_O2EM_PLATFORM)"
endef

define LIBRETRO_O2EM_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_O2EM_PKG_DIR)$(LIBRETRO_O2EM_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/o2em_libretro.so \
	$(LIBRETRO_O2EM_PKG_DIR)$(LIBRETRO_O2EM_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_O2EM_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/libretro/libretro-o2em/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_O2EM_POST_INSTALL_TARGET_HOOKS = LIBRETRO_O2EM_MAKEPKG

$(eval $(generic-package))
