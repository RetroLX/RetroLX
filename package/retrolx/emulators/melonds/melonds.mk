################################################################################
#
# MELONDS
#
################################################################################
# Version.: Relase on April 26th, 2020
MELONDS_VERSION = 0.9.2
MELONDS_SITE = https://github.com/Arisotura/melonDS.git
MELONDS_SITE_METHOD=git
MELONDS_GIT_SUBMODULES=YES
MELONDS_LICENSE = GPLv2
MELONDS_DEPENDENCIES = sdl2 qt5base slirp

MELONDS_PKG_DIR = $(TARGET_DIR)/opt/retrolx/melonds
MELONDS_PKG_INSTALL_DIR = /userdata/packages/$(BATOCERA_SYSTEM_ARCH)/melonds

# Should be set when the package cannot be built inside the source tree but needs a separate build directory.
MELONDS_SUPPORTS_IN_SOURCE_BUILD = NO

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
	cd $(MELONDS_PKG_DIR) && $(BR2_EXTERNAL_BATOCERA_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_BATOCERA_PATH)/package/retrolx/emulators/melonds/PKGINFO \
	$(BATOCERA_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_BATOCERA_PATH)/repo/$(BATOCERA_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

MELONDS_POST_INSTALL_TARGET_HOOKS = MELONDS_MAKEPKG

$(eval $(cmake-package))
