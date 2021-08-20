################################################################################
#
# DosBox
#
################################################################################
# Version.: Commits on Jan 08, 2020
DOSBOX_VERSION = 411481d3c760a7f25bc530c97da7ae008e63e0ad
DOSBOX_SITE = $(call github,duganchen,dosbox,$(DOSBOX_VERSION))
DOSBOX_DEPENDENCIES = sdl2 sdl2_net sdl_sound zlib libpng libogg libvorbis
DOSBOX_LICENSE = GPLv2

DOSBOX_PKG_DIR = $(TARGET_DIR)/opt/retrolx/dosbox
DOSBOX_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/dosbox

define DOSBOX_CONFIGURE_CMDS
    cd $(@D); ./autogen.sh; $(TARGET_CONFIGURE_OPTS) CROSS_COMPILE="$(HOST_DIR)/usr/bin/" LIBS="-lvorbisfile -lvorbis -logg" \
        ./configure --host="$(GNU_TARGET_NAME)" \
                    --enable-core-inline \
                    --enable-dynrec \
                    --enable-unaligned_memory \
                    --prefix=/opt/retrolx/dosbox$(DOSBOX_PKG_INSTALL_DIR) \
                    --with-sdl-prefix="$(STAGING_DIR)/usr";
endef

define DOSBOX_MAKE_PKG
	# Create directories
	mkdir -p $(DOSBOX_PKG_DIR)$(DOSBOX_PKG_INSTALL_DIR)

	# Copy configgen
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/dosbox/*.py \
	$(DOSBOX_PKG_DIR)$(DOSBOX_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(DOSBOX_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/dosbox/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

DOSBOX_POST_INSTALL_TARGET_HOOKS += DOSBOX_MAKE_PKG

$(eval $(autotools-package))
