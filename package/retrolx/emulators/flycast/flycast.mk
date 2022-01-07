################################################################################
#
# FLYCAST
#
################################################################################
# Version.: Release on Dec 17, 2021
FLYCAST_VERSION = v1.2
FLYCAST_SITE = https://github.com/flyinghead/flycast.git
FLYCAST_SITE_METHOD=git
FLYCAST_GIT_SUBMODULES=YES
FLYCAST_LICENSE = GPLv2
FLYCAST_DEPENDENCIES = sdl2 libpng libzip

FLYCAST_PKG_DIR = $(TARGET_DIR)/opt/retrolx/flycast
FLYCAST_PKG_INSTALL_DIR = /userdata/packages/$(RETROLX_SYSTEM_ARCH)/flycast

FLYCAST_CONF_OPTS += -DLIBRETRO=OFF

ifeq ($(BR2_PACKAGE_UDEV),y)
	FLYCAST_DEPENDENCIES += udev
endif

# GLES 3
ifeq ($(BR2_PACKAGE_RETROLX_HAS_GLES3),y)
FLYCAST_CONF_OPTS += -DUSE_GLES=ON
# GLES 2
else ifeq ($(BR2_PACKAGE_RETROLX_HAS_GLES2),y)
FLYCAST_CONF_OPTS += -DUSE_GLES2=ON
endif

FLYCAST_SUPPORTS_IN_SOURCE_BUILD = NO

define FLYCAST_INSTALL_TARGET_CMDS
	echo "flycast built as package, no rootfs install"
endef

#define FLYCAST_PATCH_VULKAN_WAYLAND
#	cd $(@D) && patch -p1 < $(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/flycast/xxx-vulkan-wayland.diff
#endef

ifeq ($(BR2_PACKAGE_RETROLX_VULKAN),y)
#	FLYCAST_PRE_BUILD_HOOKS += FLYCAST_PATCH_VULKAN_WAYLAND
	FLYCAST_CONF_OPTS += -DUSE_VULKAN=1
	FLYCAST_EXTRA_ARGS += EXTRAFLAGS=-ldl
endif

ifeq ($(BR2_PACKAGE_HAS_LIBMALI),y)
FLYCAST_EXTRA_ARGS += EXTRAFLAGS=-Wl,-lmali
endif

define FLYCAST_INSTALL_TARGET_CMDS
	echo "flycast built as package, no rootfs install"
endef

define FLYCAST_MAKEPKG
	# Create directories
	mkdir -p $(FLYCAST_PKG_DIR)$(FLYCAST_PKG_INSTALL_DIR)

	# Fix rpath
	$(HOST_DIR)/bin/patchelf --remove-rpath $(@D)/buildroot-build/flycast

	# Copy package files
	$(INSTALL) -D -m 0755 $(@D)/buildroot-build/flycast $(FLYCAST_PKG_DIR)$(FLYCAST_PKG_INSTALL_DIR)/flycast

	# Build Pacman package
	cd $(FLYCAST_PKG_DIR) && $(BR2_EXTERNAL_RETROLX_PATH)/scripts/retrolx-makepkg \
	$(BR2_EXTERNAL_RETROLX_PATH)/package/retrolx/emulators/flycast/PKGINFO \
	$(RETROLX_SYSTEM_ARCH) $(HOST_DIR)
	mv $(TARGET_DIR)/opt/retrolx/*.zst $(BR2_EXTERNAL_RETROLX_PATH)/repo/$(RETROLX_SYSTEM_ARCH)/

	# Cleanup
	rm -Rf $(TARGET_DIR)/opt/retrolx/*
endef

FLYCAST_POST_INSTALL_TARGET_HOOKS = FLYCAST_MAKEPKG

$(eval $(cmake-package))
