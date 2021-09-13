################################################################################
#
# DOSBOX PURE
#
################################################################################
# Version.: Commits on Sep 13, 2021
LIBRETRO_DOSBOX_PURE_VERSION = 0.17
LIBRETRO_DOSBOX_PURE_SITE = $(call github,schellingb,dosbox-pure,$(LIBRETRO_DOSBOX_PURE_VERSION))
LIBRETRO_DOSBOX_PURE_LICENSE = GPLv2

LIBRETRO_DOSBOX_PURE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/libretro
LIBRETRO_DOSBOX_PURE_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/lr-dosbox-pure

# x86
ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86),y)
LIBRETRO_DOSBOX_PURE_EXTRA_ARGS = target=x86 WITH_FAKE_SDL=1

# x86_64
else ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86_64),y)
LIBRETRO_DOSBOX_PURE_EXTRA_ARGS = target=x86_64 WITH_FAKE_SDL=1

else ifeq ($(BR2_arm),y)
LIBRETRO_DOSBOX_PURE_EXTRA_ARGS = target=arm WITH_FAKE_SDL=1

else ifeq ($(BR2_aarch64),y)
LIBRETRO_DOSBOX_PURE_EXTRA_ARGS = target=arm64 WITH_FAKE_SDL=1
endif

define LIBRETRO_DOSBOX_PURE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" cross_prefix="$(STAGING_DIR)/usr/bin/" -C $(@D) -f Makefile \
		platform=$(RETROLX_SYSTEM) $(LIBRETRO_DOSBOX_PURE_EXTRA_ARGS)
endef

define LIBRETRO_DOSBOX_PURE_INSTALL_TARGET_CMDS
endef

define LIBRETRO_DOSBOX_PURE_MAKEPKG
	# Create directories
	mkdir -p $(LIBRETRO_DOSBOX_PURE_PKG_DIR)$(LIBRETRO_DOSBOX_PURE_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/dosbox_pure_libretro.so \
	$(LIBRETRO_DOSBOX_PURE_PKG_DIR)$(LIBRETRO_DOSBOX_PURE_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(LIBRETRO_DOSBOX_PURE_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/libretro/libretro-dosbox-pure/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

LIBRETRO_DOSBOX_PURE_POST_INSTALL_TARGET_HOOKS = LIBRETRO_DOSBOX_PURE_MAKEPKG

$(eval $(generic-package))
