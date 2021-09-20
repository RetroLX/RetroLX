################################################################################
#
# DUCKSTATION
#
################################################################################
# Version.: Commits on Sep 14, 2021
DUCKSTATION_VERSION = bacd834840a12b7df19df175bb5cbf286c93d43f
DUCKSTATION_SITE = https://github.com/stenzek/duckstation.git

DUCKSTATION_DEPENDENCIES = fmt boost ffmpeg ecm
DUCKSTATION_SITE_METHOD=git
DUCKSTATION_GIT_SUBMODULES=YES
DUCKSTATION_LICENSE = GPLv2

DUCKSTATION_CONF_OPTS  = -DENABLE_DISCORD_PRESENCE=OFF -DANDROID=OFF -DBUILD_LIBRETRO_CORE=OFF
DUCKSTATION_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
DUCKSTATION_CONF_OPTS += -DBUILD_SHARED_LIBS=FALSE

DUCKSTATION_PKG_DIR = $(TARGET_DIR)/opt/retrolx/duckstation
DUCKSTATION_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/duckstation

ifeq ($(BR2_PACKAGE_RETROLX_TARGET_X86_64),y)
DUCKSTATION_CONF_OPTS += -DBUILD_QT_FRONTEND=ON -DBUILD_SDL_FRONTEND=OFF -DUSE_WAYLAND=OFF -DUSE_X11=ON -DUSE_GLX=ON -DUSE_EGL=OFF
DUCKSTATION_DEPENDENCIES += qt5base qt5tools qt5multimedia
DUCKSTATION_BINARY = duckstation-qt
else
DUCKSTATION_CONF_OPTS += -DBUILD_QT_FRONTEND=OFF -DBUILD_SDL_FRONTEND=OFF -DBUILD_NOGUI_FRONTEND=ON -DUSE_DRMKMS=OFF -DUSE_WAYLAND=ON -DUSE_X11=OFF
DUCKSTATION_CONF_OPTS += -DCMAKE_C_FLAGS=-DEGL_NO_X11 -DCMAKE_CXX_FLAGS=-DEGL_NO_X11
DUCKSTATION_DEPENDENCIES += libdrm sdl2 libevdev
DUCKSTATION_BINARY = duckstation-nogui
endif

ifeq ($(BR2_PACKAGE_HAS_LIBEGL),y)
DUCKSTATION_CONF_OPTS += -DUSE_EGL=ON
ifeq ($(BR2_PACKAGE_HAS_LIBMALI),y)
DUCKSTATION_CONF_OPTS += -DUSE_MALI=ON
endif
else
DUCKSTATION_CONF_OPTS += -DUSE_EGL=OFF
endif

DUCKSTATION_CONF_ENV += LDFLAGS=-lpthread

# Should be set when the package cannot be built inside the source tree but needs a separate build directory.
DUCKSTATION_SUPPORTS_IN_SOURCE_BUILD = NO

define DUCKSTATION_INSTALL_TARGET_CMDS
	echo "DuckStation is built as a Pacman package, skip rootfs install"
endef

define DUCKSTATION_MAKEPKG
	# Create package directory
	mkdir -p $(DUCKSTATION_PKG_DIR)$(DUCKSTATION_PKG_INSTALL_DIR)

	# Copy package files
	cp -R $(@D)/buildroot-build/bin/* $(DUCKSTATION_PKG_DIR)$(DUCKSTATION_PKG_INSTALL_DIR)
	mv $(DUCKSTATION_PKG_DIR)$(DUCKSTATION_PKG_INSTALL_DIR)/$(DUCKSTATION_BINARY) $(DUCKSTATION_PKG_DIR)/$(DUCKSTATION_PKG_INSTALL_DIR)/duckstation
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/duckstation/psx.duckstation.keys $(DUCKSTATION_PKG_DIR)$(DUCKSTATION_PKG_INSTALL_DIR)
	cp $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/duckstation/*.py $(DUCKSTATION_PKG_DIR)$(DUCKSTATION_PKG_INSTALL_DIR)

	# Build Pacman package
	cd $(DUCKSTATION_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/duckstation/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

DUCKSTATION_POST_INSTALL_TARGET_HOOKS = DUCKSTATION_MAKEPKG

$(eval $(cmake-package))
