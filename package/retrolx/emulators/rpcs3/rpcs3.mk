################################################################################
#
# RPCS3
#
################################################################################

# 2022 Sep, 1 release
RPCS3_VERSION = v0.0.24

RPCS3_SITE = https://github.com/RPCS3/rpcs3.git
RPCS3_SITE_METHOD=git
RPCS3_GIT_SUBMODULES=YES
RPCS3_LICENSE = GPLv2
RPCS3_DEPENDENCIES = qt5declarative libxml2 mesa3d libglu openal alsa-lib libevdev libglew libusb ffmpeg faudio

RPCS3_PKG_DIR = $(TARGET_DIR)/opt/retrolx/rpcs3
RPCS3_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/rpcs3
RPCS3_PREFIX_DIR = /opt/retrolx/rpcs3$(RPCS3_PKG_INSTALL_DIR)

RPCS3_CONF_OPTS += -DUSE_PULSE=ON
RPCS3_CONF_OPTS += -DUSE_SYSTEM_FFMPEG=ON
RPCS3_CONF_OPTS += -DUSE_SYSTEM_LIBPNG=ON
RPCS3_CONF_OPTS += -DUSE_DISCORD_RPC=OFF
RPCS3_CONF_OPTS += -DUSE_VULKAN=ON
RPCS3_CONF_OPTS += -DCMAKE_CROSSCOMPILING=ON
RPCS3_CONF_OPTS += -DWITH_LLVM=ON
RPCS3_CONF_OPTS += -DBUILD_LLVM_SUBMODULE=ON
RPCS3_CONF_OPTS += -DUSE_NATIVE_INSTRUCTIONS=OFF
RPCS3_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF
RPCS3_CONF_OPTS += -DUSE_SYSTEM_FAUDIO=ON
RPCS3_CONF_OPTS += -DUSE_SYSTEM_WOLFSSL=OFF
RPCS3_CONF_OPTS += -DUSE_SYSTEM_ZLIB=OFF
RPCS3_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

# Should be set when the package cannot be built inside the source tree but needs a separate build directory.
RPCS3_SUPPORTS_IN_SOURCE_BUILD = NO

# Install into package prefix
RPCS3_INSTALL_TARGET_OPTS = DESTDIR="$(RPCS3_PKG_DIR)$(RPCS3_PKG_INSTALL_DIR)" install

define RPCS3_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) \
	$(MAKE) -C $(@D)/buildroot-build
endef

define RPCS3_MAKEPKG
	 #evmapy config
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/rpcs3/evmapy.keys $(RPCS3_PKG_DIR)$(RPCS3_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(RPCS3_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/rpcs3/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

RPCS3_POST_INSTALL_TARGET_HOOKS = RPCS3_MAKEPKG

$(eval $(cmake-package))
