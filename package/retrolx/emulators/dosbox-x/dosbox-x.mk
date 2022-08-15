################################################################################
#
# DosBox-X
#
################################################################################
# Version.: Commits on Aug 1, 2022
DOSBOX_X_VERSION = dosbox-x-windows-v2022.08.0
DOSBOX_X_SITE = $(call github,joncampbell123,dosbox-x,$(DOSBOX_X_VERSION))
DOSBOX_X_DEPENDENCIES = sdl2 sdl2_net sdl_sound zlib libpng libogg libvorbis ffmpeg
DOSBOX_X_LICENSE = GPLv2

DOSBOX_X_PKG_DIR = $(TARGET_DIR)/opt/retrolx/dosbox-x
DOSBOX_X_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/dosbox-x

ifeq ($(BR2_arm)$(BR2_aarch64),y)
DOSBOX_X_PLATFORM_CONF_OPTS += --disable-x11 --enable-scaler-full-line
endif

define DOSBOX_X_CONFIGURE_CMDS
	# Create directories
	mkdir -p $(DOSBOX_X_PKG_DIR)

	cd $(@D); ./autogen.sh; $(TARGET_CONFIGURE_OPTS) CROSS_COMPILE="$(HOST_DIR)/usr/bin/" PREFIX="$(STAGING_DIR)" SYSROOT="$(STAGING_DIR)" LIBS="-lvorbisfile -lvorbis -logg" \
        ./configure --host="$(GNU_TARGET_NAME)" \
                    --enable-core-inline \
                    --enable-dynrec \
                    --enable-unaligned_memory \
                    --prefix=/opt/retrolx/dosbox-x$(DOSBOX_X_PKG_INSTALL_DIR) \
                    --disable-sdl \
                    --enable-sdl2 \
                    --with-sdl2-prefix="$(STAGING_DIR)/usr" \
		    $(DOSBOX_PLATFORM_CONF_OPTS)
endef

define DOSBOX_X_CONFIGURE_CONFIG
    mkdir -p $(TARGET_DIR)/usr/share/retrolx/datainit/system/configs/dosbox-x

    cp -rf $(@D)/dosbox-x.reference.conf \
        $(TARGET_DIR)/usr/share/retrolx/datainit/system/configs/dosbox-x/dosbox-x.conf
endef

DOSBOX_X_POST_INSTALL_TARGET_HOOKS += DOSBOX_X_CONFIGURE_CONFIG

define DOSBOX_X_MAKE_PKG
	# Create directories
	mkdir -p $(DOSBOX_X_PKG_DIR)$(DOSBOX_X_PKG_INSTALL_DIR)

	# Copy configgen
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/dosbox-x/*.py \
	$(DOSBOX_X_PKG_DIR)$(DOSBOX_X_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(DOSBOX_X_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/dosbox-x/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

DOSBOX_X_POST_INSTALL_TARGET_HOOKS += DOSBOX_X_MAKE_PKG

$(eval $(autotools-package))
