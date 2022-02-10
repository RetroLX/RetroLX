################################################################################
#
# Hypseus + Singe (a fork of Daphne)
#
################################################################################
# Version.: Release on Feb 10, 2022
DAPHNE_VERSION = v2.8.1
DAPHNE_SITE = https://github.com/DirtBagXon/hypseus-singe
DAPHNE_SITE_METHOD=git
DAPHNE_LICENSE = GPLv3
DAPHNE_DEPENDENCIES = sdl2 sdl2_image sdl2_ttf zlib libogg libvorbis libmpeg2

DAPHNE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/daphne
DAPHNE_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/daphne

# Should be set when the package cannot be built inside the source tree but needs a separate build directory.
DAPHNE_SUBDIR = build
DAPHNE_CONF_OPTS = ../src -DBUILD_SHARED_LIBS=OFF

define DAPHNE_INSTALL_TARGET_CMDS
	echo "Daphne built as pacman package, no rootfs install"
endef

define DAPHNE_MAKEPKG
	# Create directories
	mkdir -p $(DAPHNE_PKG_DIR)$(DAPHNE_PKG_INSTALL_DIR)/pics
	mkdir -p $(DAPHNE_PKG_DIR)$(DAPHNE_PKG_INSTALL_DIR)/fonts
	mkdir -p $(DAPHNE_PKG_DIR)$(DAPHNE_PKG_INSTALL_DIR)/sound

	# Copy package files
	$(INSTALL) -D $(@D)/build/hypseus $(DAPHNE_PKG_DIR)$(DAPHNE_PKG_INSTALL_DIR)

	cp -pr $(@D)/pics  $(DAPHNE_PKG_DIR)$(DAPHNE_PKG_INSTALL_DIR)
	cp -pr $(@D)/fonts $(DAPHNE_PKG_DIR)$(DAPHNE_PKG_INSTALL_DIR)
	cp -pr $(@D)/sound $(DAPHNE_PKG_DIR)$(DAPHNE_PKG_INSTALL_DIR)

	ln -fs /userdata/system/configs/daphne/hypinput.ini $(DAPHNE_PKG_DIR)$(DAPHNE_PKG_INSTALL_DIR)/hypinput.ini

	# Build Pacman package
	cd $(DAPHNE_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/daphne/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

DAPHNE_POST_INSTALL_TARGET_HOOKS = DAPHNE_MAKEPKG

$(eval $(cmake-package))
