################################################################################
#
# CITRA ANDROID
#
################################################################################
# Version.: Commits on Sep 08, 2021
CITRA_ANDROID_DEPENDENCIES = fmt boost ffmpeg sdl2 fdk-aac
CITRA_ANDROID_SITE_METHOD=git
CITRA_ANDROID_GIT_SUBMODULES=YES
CITRA_ANDROID_LICENSE = GPLv2

CITRA_ANDROID_PKG_DIR = $(TARGET_DIR)/opt/retrolx/citra-android
CITRA_ANDROID_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/citra-android

# Use citra-android for AArch64 (SDL2 only)
CITRA_ANDROID_VERSION = 6f6f9a091085305154375028f3342aad16697f3c
CITRA_ANDROID_SITE = https://github.com/citra-emu/citra-android.git
CITRA_ANDROID_CONF_OPTS += -DENABLE_QT=OFF

# Should be set when the package cannot be built inside the source tree but needs a separate build directory.
CITRA_ANDROID_SUPPORTS_IN_SOURCE_BUILD = NO

CITRA_ANDROID_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
CITRA_ANDROID_CONF_OPTS += -DENABLE_WEB_SERVICE=OFF
CITRA_ANDROID_CONF_OPTS += -DENABLE_FFMPEG=ON
CITRA_ANDROID_CONF_OPTS += -DBUILD_SHARED_LIBS=FALSE
CITRA_ANDROID_CONF_OPTS += -DENABLE_FFMPEG_AUDIO_DECODER=ON

CITRA_ANDROID_CONF_ENV += LDFLAGS=-lpthread

define CITRA_ANDROID_INSTALL_TARGET_CMDS
	echo "Citra Android built as pacman package, no rootfs install"
endef

define CITRA_ANDROID_MAKEPKG
	# Create directories
	mkdir -p $(CITRA_ANDROID_PKG_DIR)$(CITRA_ANDROID_PKG_INSTALL_DIR)

	# Copy package files
	$(INSTALL) -D $(@D)/buildroot-build/bin/Release/citra \
	$(CITRA_ANDROID_PKG_DIR)$(CITRA_ANDROID_PKG_INSTALL_DIR)	
	cp -prn $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/citra-android/3ds.citra.keys \
	$(CITRA_ANDROID_PKG_DIR)$(CITRA_ANDROID_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(CITRA_ANDROID_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/citra-android/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

CITRA_ANDROID_POST_INSTALL_TARGET_HOOKS = CITRA_ANDROID_MAKEPKG

$(eval $(cmake-package))
