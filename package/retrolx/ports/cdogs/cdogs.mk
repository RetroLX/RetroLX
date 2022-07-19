################################################################################
#
# C-Dogs
#
################################################################################
# Version.: Release on Jun 13, 2022
CDOGS_VERSION = 1.3.1
CDOGS_SITE = $(call github,cxong,cdogs-sdl,$(CDOGS_VERSION))

CDOGS_DEPENDENCIES = sdl2 host-python-protobuf
CDOGS_LICENSE = GPL-2.0

CDOGS_PKG_DIR = $(TARGET_DIR)/opt/retrolx/cdogs
CDOGS_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/cdogs

# Install into package prefix
CDOGS_INSTALL_TARGET_OPTS = DESTDIR="$(CDOGS_PKG_DIR)$(CDOGS_PKG_INSTALL_DIR)" install

CDOGS_SUPPORTS_IN_SOURCE_BUILD = NO

CDOGS_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
CDOGS_CONF_OPTS += -DCDOGS_DATA_DIR=$(CDOGS_PKG_DIR)$(CDOGS_PKG_INSTALL_DIR)
CDOGS_CONF_OPTS += -DBUILD_EDITOR=OFF

define CDOGS_MAKEPKG
	# Tidy up package
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/cdogs/*.py $(CDOGS_PKG_DIR)$(CDOGS_PKG_INSTALL_DIR)
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/cdogs/cdogs.keys $(CDOGS_PKG_DIR)$(CDOGS_PKG_INSTALL_DIR)
	cp -f $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/cdogs/gamecontrollerdb.txt $(CDOGS_PKG_DIR)$(CDOGS_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(CDOGS_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/cdogs/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

CDOGS_POST_INSTALL_TARGET_HOOKS = CDOGS_MAKEPKG

$(eval $(cmake-package))
