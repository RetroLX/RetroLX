################################################################################
#
# SIMCOUPE
#
################################################################################
# Version.: Release on May 5, 2021
SIMCOUPE_VERSION = v1.2.11
SIMCOUPE_SITE = $(call github,simonowen,simcoupe,$(SIMCOUPE_VERSION))
SIMCOUPE_LICENSE = GPLv2
SIMCOUPE_DEPENDENCIES = sdl2 zlib libpng

SIMCOUPE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/simcoupe
SIMCOUPE_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/simcoupe

SIMCOUPE_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF
SIMCOUPE_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

# Install into package prefix
SIMCOUPE_MAKE_OPTS += DESTDIR="$(SIMCOUPE_PKG_DIR)"
SIMCOUPE_INSTALL_TARGET_OPTS = DESTDIR="$(SIMCOUPE_PKG_DIR)$(SIMCOUPE_PKG_INSTALL_DIR)" install

define SIMCOUPE_MAKEPKG
	# Build Pacman package
	cd $(SIMCOUPE_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/simcoupe/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

SIMCOUPE_POST_INSTALL_TARGET_HOOKS = SIMCOUPE_MAKEPKG

$(eval $(cmake-package))
