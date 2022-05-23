################################################################################
#
# PCSX2
#
################################################################################

PCSX2_VERSION = v1.7.2784
PCSX2_SITE = https://github.com/pcsx2/pcsx2.git
PCSX2_LICENSE = GPLv2 GPLv3 LGPLv2.1 LGPLv3
PCSX2_DEPENDENCIES = xserver_xorg-server alsa-lib freetype zlib libpng wxwidgets libaio libsoundtouch sdl2 libpcap libgtk3 libsamplerate fmt

PCSX2_SITE_METHOD = git
PCSX2_GIT_SUBMODULES = YES

PCSX2_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
PCSX2_CONF_OPTS += -DXDG_STD=TRUE
PCSX2_CONF_OPTS += -DSDL2_API=TRUE
PCSX2_CONF_OPTS += -DDISABLE_PCSX2_WRAPPER=1
PCSX2_CONF_OPTS += -DPACKAGE_MODE=FALSE
PCSX2_CONF_OPTS += -DwxWidgets_CONFIG_EXECUTABLE="$(STAGING_DIR)/usr/bin/wx-config"
PCSX2_CONF_OPTS += -DPCSX2_TARGET_ARCHITECTURES=x86_64
PCSX2_CONF_OPTS += -DENABLE_TESTS=OFF
PCSX2_CONF_OPTS += -DUSE_SYSTEM_YAML=OFF
PCSX2_CONF_OPTS += -DEXTRA_PLUGINS=TRUE
#PCSX2_CONF_OPTS += -DwxUSE_UNICODE=0
#PCSX2_CONF_OPTS += -DwxUSE_UNICODE_UTF8=0
PCSX2_CONF_OPTS += -DBUILD_SHARED_LIBS=ON
PCSX2_CONF_OPTS += -DDISABLE_ADVANCE_SIMD=ON
PCSX2_CONF_OPTS += -DUSE_VTUNE=OFF
PCSX2_CONF_OPTS += -DUSE_VULKAN=ON

PCSX2_PKG_DIR = $(TARGET_DIR)/opt/retrolx/pcsx2
PCSX2_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/pcsx2

# Should be set when the package cannot be built inside the source tree but needs a separate build directory.
PCSX2_SUPPORTS_IN_SOURCE_BUILD = NO

define PCSX2_INSTALL_TARGET_CMDS
	echo "PCSX2 built as pacman package, no rootfs install"
endef

define PCSX2_MAKEPKG
	# Create directories
	mkdir -p $(PCSX2_PKG_DIR)$(PCSX2_PKG_INSTALL_DIR)
	mkdir -p $(PCSX2_PKG_DIR)$(PCSX2_PKG_INSTALL_DIR)

	# Copy package files
	cp -pr $(@D)/buildroot-build/pcsx2/*			$(PCSX2_PKG_DIR)$(PCSX2_PKG_INSTALL_DIR)
	cp -pr $(@D)/buildroot-build/common/libcommon.so	$(PCSX2_PKG_DIR)$(PCSX2_PKG_INSTALL_DIR)
	cp -pr $(@D)/buildroot-build/3rdparty/glad/libglad.so	$(PCSX2_PKG_DIR)$(PCSX2_PKG_INSTALL_DIR)
	#$(INSTALL) -m 0755 -D 					$(@D)/buildroot-build/pcsx2/pcsx2 $(PCSX2_PKG_DIR)$(PCSX2_PKG_INSTALL_DIR)/pcsx2
	#cp $(@D)/bin/PCSX2_*      				$(PCSX2_PKG_DIR)$(PCSX2_PKG_INSTALL_DIR)
	#cp $(@D)/bin/portable.ini      			$(PCSX2_PKG_DIR)$(PCSX2_PKG_INSTALL_DIR)
	#cp -pr $(@D)/bin/resources     			$(PCSX2_PKG_DIR)$(PCSX2_PKG_INSTALL_DIR)
	#cp -pr $(@D)/bin/shaders     				$(PCSX2_PKG_DIR)$(PCSX2_PKG_INSTALL_DIR)
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/pcsx2/ps2.pcsx2.keys $(PCSX2_PKG_DIR)$(PCSX2_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(PCSX2_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/pcsx2/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

PCSX2_POST_INSTALL_TARGET_HOOKS += PCSX2_MAKEPKG

$(eval $(cmake-package))
