################################################################################
#
# drastic
#
################################################################################

DRASTIC_VERSION = 1.0
DRASTIC_SOURCE = drastic.tar.gz
DRASTIC_SITE = https://github.com/liberodark/drastic/releases/download/$(DRASTIC_VERSION)

DRASTIC_PKG_DIR = $(TARGET_DIR)/opt/retrolx/drastic
DRASTIC_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/drastic

define DRASTIC_EXTRACT_CMDS
	mkdir -p $(@D)/target && cd $(@D)/target && tar xf $(DL_DIR)/$(DRASTIC_DL_SUBDIR)/$(DRASTIC_SOURCE)
endef

ifeq ($(BR2_cortex_a35),y)
DRASTIC_BINARYFILE=drastic_oga
else ifeq ($(BR2_aarch64),y)
DRASTIC_BINARYFILE=drastic_n2
endif

define DRASTIC_MAKEPKG
	# Copy package files
	$(INSTALL) -D $(@D)/target/$(DRASTIC_BINARYFILE) $(DRASTIC_PKG_DIR)$(DRASTIC_PKG_INSTALL_DIR)/drastic
	cp -pr $(@D)/target/drastic/* $(DRASTIC_PKG_DIR)$(DRASTIC_PKG_INSTALL_DIR)
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/drastic/controllers/nds.drastic.keys $(DRASTIC_PKG_DIR)$(DRASTIC_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(DRASTIC_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/drastic/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

DRASTIC_POST_INSTALL_TARGET_HOOKS = DRASTIC_MAKEPKG

$(eval $(generic-package))
