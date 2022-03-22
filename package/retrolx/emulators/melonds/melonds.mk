################################################################################
#
# MELONDS
#
################################################################################
# Version.: Relase on Mar 8, 2022
MELONDS_VERSION = 0.9.4
MELONDS_SITE = https://github.com/Arisotura/melonDS.git
MELONDS_SITE_METHOD=git
MELONDS_GIT_SUBMODULES=YES
MELONDS_LICENSE = GPLv2
MELONDS_DEPENDENCIES = sdl2 qt5base slirp

MELONDS_PKG_DIR = $(TARGET_DIR)/opt/retrolx/melonds
MELONDS_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/melonds

# Should be set when the package cannot be built inside the source tree but needs a separate build directory.
MELONDS_SUPPORTS_IN_SOURCE_BUILD = NO

# melonDS is OpenGL desktop only so far
ifeq ($(BR2_x86_64), y)
MELONDS_CONF_OPTS += -DENABLE_OGLRENDERER=ON
else
MELONDS_CONF_OPTS += -DENABLE_OGLRENDERER=OFF
endif

MELONDS_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

MELONDS_CONF_ENV += LDFLAGS=-lpthread

define MELONDS_INSTALL_TARGET_CMDS
	echo "melonDS built as pacman package, no rootfs install"
endef

define MELONDS_MAKEPKG
	# Copy package files
	$(INSTALL) -D $(@D)/buildroot-build/melonDS \
	$(MELONDS_PKG_DIR)$(MELONDS_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(MELONDS_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/melonds/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

MELONDS_POST_INSTALL_TARGET_HOOKS = MELONDS_MAKEPKG

$(eval $(cmake-package))
