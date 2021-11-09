################################################################################
#
# Abuse
#
################################################################################
# Version.: Commits on Aug 18, 2021
ABUSE_VERSION = eb33c63145587454d9d6ce9e5d0d535208bc15e5
ABUSE_SITE = $(call github,Xenoveritas,abuse,$(ABUSE_VERSION))

ABUSE_DEPENDENCIES = sdl2 sdl2_mixer
ABUSE_SUPPORTS_IN_SOURCE_BUILD = NO
ABUSE_CONF_OPTS += -DASSETDIR=$(ABUSE_PKG_DIR)$(ABUSE_PKG_INSTALL_DIR)

ABUSE_DATA_SITE = abuse.zoy.org/raw-attachment/wiki/download
ABUSE_DATA_SOURCE = abuse-data-2.00.tar.gz
ABUSE_DATA_LICENSE = Public Domain

ABUSE_PKG_DIR = $(TARGET_DIR)/opt/retrolx/abuse
ABUSE_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/abuse

# Install into package prefix
ABUSE_INSTALL_TARGET_OPTS = DESTDIR="$(ABUSE_PKG_DIR)$(ABUSE_PKG_INSTALL_DIR)" install

define ABUSE_MAKEDIR
	# Create package directory
	mkdir -p $(ABUSE_PKG_DIR)$(ABUSE_PKG_INSTALL_DIR)
endef

define ABUSE_MAKEPKG
	# Copy data
	cd $(ABUSE_DL_DIR) && wget $(ABUSE_DATA_SITE)/$(ABUSE_DATA_SOURCE)
	tar -xf $(ABUSE_DL_DIR)/$(ABUSE_DATA_SOURCE) -C $(ABUSE_PKG_DIR)$(ABUSE_PKG_INSTALL_DIR)
	rm $(ABUSE_DL_DIR)/$(ABUSE_DATA_SOURCE)

	# Tidy up package
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/abuse/*.py $(ABUSE_PKG_DIR)$(ABUSE_PKG_INSTALL_DIR)
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/abuse/abuse.keys  $(ABUSE_PKG_DIR)$(ABUSE_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(ABUSE_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/ports/abuse/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

ABUSE_POST_INSTALL_TARGET_HOOKS = ABUSE_MAKEPKG
ABUSE_PRE_INSTALL_TARGET_HOOKS = ABUSE_MAKEDIR

$(eval $(cmake-package))
