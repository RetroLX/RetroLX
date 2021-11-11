################################################################################
#
# VITA3K
#
################################################################################
# Version.: Commits on Nov 18, 2021
VITA3K_VERSION = afb2ea52fc485975a51e5cc525b28fc9568c20b0
VITA3K_SITE = https://github.com/vita3k/vita3k
VITA3K_SITE_METHOD=git
VITA3K_GIT_SUBMODULES=YES
VITA3K_LICENSE = GPLv3
VITA3K_DEPENDENCIES = sdl2 sdl2_image sdl2_ttf zlib libogg libvorbis

VITA3K_PKG_DIR = $(TARGET_DIR)/opt/retrolx/vita3k
VITA3K_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/vita3k

# Should be set when the package cannot be built inside the source tree but needs a separate build directory.
VITA3K_SUPPORTS_IN_SOURCE_BUILD = NO

VITA3K_CONF_OPTS = -DBUILD_SHARED_LIBS=OFF -DUSE_DISCORD_RICH_PRESENCE=OFF

define VTA3K_INSTALL_TARGET_CMDS
	echo "Vita3K built as package, no rootfs install"
endef

define VITA3K_MAKEPKG
	# Create directory and copy build output
	mkdir -p $(VITA3K_PKG_DIR)$(VITA3K_PKG_INSTALL_DIR)
	cp -R $(@D)/buildroot-build/bin/* $(VITA3K_PKG_DIR)$(VITA3K_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(VITA3K_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/vita3k/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

VITA3K_POST_INSTALL_TARGET_HOOKS = VITA3K_MAKEPKG

$(eval $(cmake-package))
